from typing import Literal

from pydantic import BaseModel


class QuizResult(BaseModel):
    session_id: str
    title: str | None
    attended_at: str | None
    my_score: int
    grade: Literal["excellent", "needs_practice", "needs_review"]


class QuizResultList(BaseModel):
    results: list[QuizResult]
