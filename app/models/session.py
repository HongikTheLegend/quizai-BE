from pydantic import BaseModel


class SessionCreate(BaseModel):
    quiz_id: str


class AnswerSubmit(BaseModel):
    question_id: str
    selected: str  # option label


class SessionResponse(BaseModel):
    id: str
    quiz_id: str
    student_id: str
    status: str  # active | completed
    created_at: str

    class Config:
        from_attributes = True


class SessionResult(BaseModel):
    session_id: str
    score: int
    total: int
    understanding_level: str  # high | medium | low
    wrong_topics: list[str]
