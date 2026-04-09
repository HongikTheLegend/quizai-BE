from pydantic import BaseModel


class QuizOption(BaseModel):
    label: str  # A, B, C, D
    text: str


class QuizQuestion(BaseModel):
    id: str
    question: str
    options: list[QuizOption]
    answer: str  # correct label (A/B/C/D)
    explanation: str | None = None


class QuizResponse(BaseModel):
    id: str
    lecture_id: str
    questions: list[QuizQuestion]
    created_at: str

    class Config:
        from_attributes = True


# --- Request / Response for generate endpoint ---

class QuizGenerateRequest(BaseModel):
    lecture_id: str
    count: int = 5
    quiz_type: str = "multiple_choice"


class QuizGenerateResponse(BaseModel):
    quiz_set_id: str
    quizzes: list[QuizQuestion]
