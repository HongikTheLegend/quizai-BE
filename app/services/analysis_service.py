import json
import logging
from collections import defaultdict

from app.core.config import settings
from app.db.supabase import get_supabase

logger = logging.getLogger(__name__)

_client = None


def _get_client():
    global _client
    if _client is None:
        import anthropic
        _client = anthropic.Anthropic(api_key=settings.anthropic_api_key)
    return _client


# ──────────────────────────────────────────────
# Internal helpers
# ──────────────────────────────────────────────

def _fetch_session_data(session_id: str) -> tuple[list[dict], list[dict]]:
    """answers 목록과 퀴즈 questions 목록을 반환."""
    supabase = get_supabase()

    session_row = (
        supabase.table("sessions")
        .select("quiz_set_id")
        .eq("id", session_id)
        .single()
        .execute()
    )
    if not session_row.data:
        raise ValueError(f"세션을 찾을 수 없습니다: {session_id}")

    answers_row = (
        supabase.table("answers")
        .select("*")
        .eq("session_id", session_id)
        .execute()
    )
    answers = answers_row.data or []
    logger.info(
        "[classify] answers 조회 | session_id=%s | 총 답변 수=%d",
        session_id, len(answers),
    )

    quiz_row = (
        supabase.table("quizzes")
        .select("questions")
        .eq("id", session_row.data["quiz_set_id"])
        .single()
        .execute()
    )
    questions = quiz_row.data["questions"] if quiz_row.data else []

    return answers, questions


_OPTION_TO_INDEX = {"A": 0, "B": 1, "C": 2, "D": 3}


def _aggregate_by_student(answers: list[dict]) -> list[dict]:
    """user_id별로 답변을 집계해 정답률·오답 quiz_id 목록·answers 배열 반환."""
    student_map: dict[str, list[dict]] = defaultdict(list)
    for a in answers:
        student_map[a["user_id"]].append(a)

    result = []
    for user_id, ans_list in student_map.items():
        total = len(ans_list)
        correct = sum(1 for a in ans_list if a["is_correct"])
        result.append({
            "user_id": user_id,
            "total": total,
            "correct": correct,
            "correct_rate": round(correct / total * 100, 1) if total else 0,
            "wrong_quiz_ids": [a["quiz_id"] for a in ans_list if not a["is_correct"]],
            # 문자 selected_option("A"~"D") → 숫자(0~3)
            "answers": [
                {
                    "quiz_id": a["quiz_id"],
                    "selected_option": _OPTION_TO_INDEX.get(
                        str(a.get("selected_option", "")).upper(), -1
                    ),
                    "is_correct": a["is_correct"],
                }
                for a in ans_list
            ],
        })
    return result


def _build_classify_prompt(student_data: list[dict], questions: list[dict]) -> str:
    q_map = {q["id"]: q["question"] for q in questions}

    enriched = [
        {
            "user_id": s["user_id"],
            "correct_rate": s["correct_rate"],
            "total_questions": s["total"],
            "correct_count": s["correct"],
            "wrong_questions": [q_map.get(wid, wid) for wid in s["wrong_quiz_ids"]],
        }
        for s in student_data
    ]

    return (
        "다음 학생들의 퀴즈 답변 데이터를 분석해서 각 학생을 분류해줘.\n"
        "분류 기준:\n"
        "- excellent: 정답률 70% 이상, 개념 이해가 확실함\n"
        "- needs_practice: 정답률 50~70%, 기본 개념은 있으나 응용·심화에서 실수\n"
        "- needs_review: 정답률 50% 미만, 기초 개념 자체가 부족함\n\n"
        f"학생 데이터:\n{json.dumps(enriched, ensure_ascii=False)}\n\n"
        "반드시 아래 JSON 형식으로만 응답해. 다른 텍스트 없이 JSON만:\n"
        '{"students": [{"user_id": "...", "grade": "excellent|needs_practice|needs_review", "reason": "한 문장 이유"}], '
        '"weak_concepts": ["오답이 많은 개념1", "개념2"], '
        '"grade_distribution": {"excellent": 0, "needs_practice": 0, "needs_review": 0}}'
    )


def _call_classify_api(student_data: list[dict], questions: list[dict]) -> dict:
    client = _get_client()
    prompt = _build_classify_prompt(student_data, questions)
    response = client.messages.create(
        model="claude-sonnet-4-5",
        max_tokens=2048,
        messages=[{"role": "user", "content": prompt}],
    )
    raw = response.content[0].text.strip()
    start = raw.find("{")
    end = raw.rfind("}") + 1
    return json.loads(raw[start:end])


# ──────────────────────────────────────────────
# Public API
# ──────────────────────────────────────────────

def classify_students(session_id: str) -> dict:
    """
    세션 답변 데이터 → Claude 오답 패턴 분석 → excellent/needs_practice/needs_review 분류.

    반환:
        {
          "total_students": N,
          "avg_score": X,
          "grade_distribution": {"excellent": N, "needs_practice": N, "needs_review": N},
          "weak_concepts": [...],
          "students": [{"student_id": ..., "nickname": ..., "score": ..., "grade": ...}]
        }
    """
    answers, questions = _fetch_session_data(session_id)

    empty = {
        "total_students": 0,
        "avg_score": 0.0,
        "grade_distribution": {"excellent": 0, "needs_practice": 0, "needs_review": 0},
        "weak_concepts": [],
        "students": [],
    }
    if not answers:
        return empty

    student_data = _aggregate_by_student(answers)

    # users 테이블에서 nickname(name) 일괄 조회
    supabase = get_supabase()
    user_ids = [s["user_id"] for s in student_data]
    users_row = supabase.table("users").select("id, name").in_("id", user_ids).execute()
    nickname_map = {u["id"]: (u.get("name") or "") for u in (users_row.data or [])}

    # score map: user_id → correct_rate
    score_map = {s["user_id"]: s["correct_rate"] for s in student_data}
    # answers map: user_id → answers 배열
    answers_map = {s["user_id"]: s["answers"] for s in student_data}

    try:
        claude_result = _call_classify_api(student_data, questions)
    except Exception as e:
        logger.warning("Claude 분류 실패, 재시도: %s", e)
        claude_result = _call_classify_api(student_data, questions)

    # Claude grade + 로컬 score/nickname/answers 합치기
    students = [
        {
            "student_id": s["user_id"],
            "nickname": nickname_map.get(s["user_id"], ""),
            "score": score_map.get(s["user_id"], 0.0),
            "grade": s["grade"],
            "answers": answers_map.get(s["user_id"], []),
        }
        for s in claude_result.get("students", [])
    ]

    total = len(students)
    avg_score = round(sum(s["score"] for s in students) / total, 1) if total else 0.0

    return {
        "total_students": total,
        "avg_score": avg_score,
        "grade_distribution": claude_result.get(
            "grade_distribution",
            {"excellent": 0, "needs_practice": 0, "needs_review": 0},
        ),
        "weak_concepts": claude_result.get("weak_concepts", []),
        "students": students,
    }


def calculate_instructor_score(instructor_id: str) -> float:
    """
    강사 품질 점수 (0~100):
      - 퀴즈 시행 횟수  40% : 10회 이상 = 만점
      - 학생 평균 정답률 30% : answers 기준
      - 세션 완료율     30% : status='ended' / total_sessions
    """
    supabase = get_supabase()

    sessions_row = (
        supabase.table("sessions")
        .select("id, status")
        .eq("instructor_id", instructor_id)
        .execute()
    )
    sessions = sessions_row.data or []
    quiz_count = len(sessions)

    if quiz_count == 0:
        return 0.0

    session_ids = [s["id"] for s in sessions]

    answers_row = (
        supabase.table("answers")
        .select("is_correct")
        .in_("session_id", session_ids)
        .execute()
    )
    answers = answers_row.data or []

    avg_correct_rate = (
        sum(1 for a in answers if a["is_correct"]) / len(answers) * 100
        if answers else 0
    )
    ended = sum(1 for s in sessions if s["status"] == "ended")

    quiz_score = min(quiz_count / 10, 1.0) * 40       # 40%
    correct_score = avg_correct_rate * 0.30            # 30%
    handling_score = (ended / quiz_count) * 30         # 30%

    return round(quiz_score + correct_score + handling_score, 1)
