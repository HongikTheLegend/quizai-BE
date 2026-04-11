from fastapi import APIRouter, Depends, HTTPException, status

from app.core.dependencies import get_current_user
from app.models.student import QuizResultList
from app.services.student_service import get_my_quiz_results

router = APIRouter(prefix="/students", tags=["Students"])


@router.get("/me/quiz-results", response_model=QuizResultList)
def my_quiz_results(current_user: dict = Depends(get_current_user)):
    if current_user.get("role") != "student":
        raise HTTPException(status_code=status.HTTP_403_FORBIDDEN, detail="학생 권한이 필요합니다")

    results = get_my_quiz_results(current_user["sub"])
    return QuizResultList(results=results)
