from pydantic import BaseModel


class QuizOption(BaseModel):
    label: str  # A, B, C, D
    text: str


class QuizQuestion(BaseModel):
    id: str
    question: str
    options: list[QuizOption]
    answer: str  # correct label
    explanation: str | None = None


class QuizResponse(BaseModel):
    id: str
    lecture_id: str
    questions: list[QuizQuestion]
    created_at: str

    class Config:
        from_attributes = True
