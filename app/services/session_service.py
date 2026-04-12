import logging
import random
import string

from fastapi import HTTPException, status

from app.db.supabase import get_supabase

logger = logging.getLogger(__name__)


def _generate_session_code() -> str:
    return "".join(random.choices(string.ascii_uppercase + string.digits, k=4))


def create_session(quiz_set_id: str, instructor_id: str, time_limit: int) -> dict:
    supabase = get_supabase()

    quiz_row = supabase.table("quizzes").select("id").eq("id", quiz_set_id).execute()
    if not quiz_row.data:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="퀴즈 세트를 찾을 수 없습니다")

    # 충돌 없는 세션 코드 생성
    code = _generate_session_code()
    for _ in range(9):
        existing = supabase.table("sessions").select("id").eq("session_code", code).execute()
        if not existing.data:
            break
        code = _generate_session_code()

    result = supabase.table("sessions").insert({
        "quiz_set_id": quiz_set_id,
        "instructor_id": instructor_id,
        "session_code": code,
        "time_limit": time_limit,
        "status": "waiting",
    }).execute()

    return result.data[0]


def submit_answer(
    session_id: str,
    quiz_id: str,
    user_id: str,
    selected_option: str,
    response_time_ms: int,
) -> dict:
    supabase = get_supabase()

    session_row = (
        supabase.table("sessions")
        .select("quiz_set_id, status")
        .eq("id", session_id)
        .single()
        .execute()
    )
    if not session_row.data:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="세션을 찾을 수 없습니다")

    quiz_row = (
        supabase.table("quizzes")
        .select("questions")
        .eq("id", session_row.data["quiz_set_id"])
        .single()
        .execute()
    )
    if not quiz_row.data:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="퀴즈를 찾을 수 없습니다")

    question = next(
        (q for q in quiz_row.data["questions"] if q["id"] == quiz_id),
        None,
    )
    if not question:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="퀴즈 문제를 찾을 수 없습니다")

    # 중복 제출 방지
    existing = (
        supabase.table("answers")
        .select("id")
        .eq("session_id", session_id)
        .eq("quiz_id", quiz_id)
        .eq("user_id", user_id)
        .execute()
    )
    if existing.data:
        raise HTTPException(status_code=status.HTTP_409_CONFLICT, detail="이미 답변을 제출했습니다")

    is_correct = selected_option.upper() == question["answer"].upper()

    insert_result = supabase.table("answers").insert({
        "session_id": session_id,
        "quiz_id": quiz_id,
        "user_id": user_id,
        "selected_option": selected_option.upper(),
        "is_correct": is_correct,
        "response_time_ms": response_time_ms,
    }).execute()

    if not insert_result.data:
        logger.error(
            "[answer] insert 실패 | session_id=%s user_id=%s quiz_id=%s",
            session_id, user_id, quiz_id,
        )
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail="답변 저장에 실패했습니다",
        )

    logger.info(
        "[answer] saved | session_id=%s user_id=%s quiz_id=%s is_correct=%s",
        session_id, user_id, quiz_id, is_correct,
    )

    return {
        "is_correct": is_correct,
        "correct_option": question["answer"],
        "explanation": question.get("explanation"),
    }


def get_answer_stats(session_id: str, quiz_id: str, total_students: int) -> dict:
    supabase = get_supabase()
    answers = (
        supabase.table("answers")
        .select("id")
        .eq("session_id", session_id)
        .eq("quiz_id", quiz_id)
        .execute()
    )
    answer_count = len(answers.data)
    response_rate = round(answer_count / total_students * 100) if total_students > 0 else 0
    return {"answer_count": answer_count, "response_rate": response_rate}
