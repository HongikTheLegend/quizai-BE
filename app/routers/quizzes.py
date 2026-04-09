import uuid

from fastapi import APIRouter, Depends, HTTPException, status

from app.core.dependencies import get_current_user
from app.db.supabase import get_supabase
from app.models.quiz import (
    QuizGenerateRequest,
    QuizGenerateResponse,
    QuizOption,
    QuizQuestion,
    QuizResponse,
)
from app.services.claude_service import generate_quizzes

router = APIRouter(prefix="/quizzes", tags=["quizzes"])

_LABELS = ["A", "B", "C", "D"]


def _to_quiz_questions(raw_list: list[dict]) -> list[QuizQuestion]:
    questions = []
    for item in raw_list:
        options = [
            QuizOption(label=_LABELS[i], text=opt)
            for i, opt in enumerate(item["options"])
        ]
        answer_idx = int(item["answer"])
        questions.append(
            QuizQuestion(
                id=str(uuid.uuid4()),
                question=item["question"],
                options=options,
                answer=_LABELS[answer_idx],
                explanation=item.get("explanation"),
            )
        )
    return questions


@router.post("/generate", response_model=QuizGenerateResponse)
async def generate(
    body: QuizGenerateRequest,
    current_user: dict = Depends(get_current_user),
):
    supabase = get_supabase()

    # 강의 텍스트 조회
    lecture_row = (
        supabase.table("lectures")
        .select("id, content, instructor_id")
        .eq("id", body.lecture_id)
        .single()
        .execute()
    )
    if not lecture_row.data:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="강의를 찾을 수 없습니다")

    lecture = lecture_row.data
    if lecture["instructor_id"] != current_user["sub"]:
        raise HTTPException(status_code=status.HTTP_403_FORBIDDEN, detail="권한이 없습니다")

    # Claude 퀴즈 생성
    raw = await generate_quizzes(lecture["content"], body.count)
    questions = _to_quiz_questions(raw)

    # Supabase 저장
    quiz_set_id = str(uuid.uuid4())
    supabase.table("quizzes").insert(
        {
            "id": quiz_set_id,
            "lecture_id": body.lecture_id,
            "instructor_id": current_user["sub"],
            "quiz_type": body.quiz_type,
            "questions": [q.model_dump() for q in questions],
        }
    ).execute()

    return QuizGenerateResponse(quiz_set_id=quiz_set_id, quizzes=questions)


@router.get("/{lecture_id}", response_model=list[QuizResponse])
def get_quizzes(
    lecture_id: str,
    current_user: dict = Depends(get_current_user),
):
    supabase = get_supabase()

    rows = (
        supabase.table("quizzes")
        .select("id, lecture_id, questions, created_at")
        .eq("lecture_id", lecture_id)
        .order("created_at", desc=True)
        .execute()
    )

    return [
        QuizResponse(
            id=row["id"],
            lecture_id=row["lecture_id"],
            questions=[QuizQuestion(**q) for q in row["questions"]],
            created_at=row["created_at"],
        )
        for row in rows.data
    ]
