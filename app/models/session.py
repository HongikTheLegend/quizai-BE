from pydantic import BaseModel


class SessionStart(BaseModel):
    quiz_set_id: str
    time_limit: int  # seconds


class SessionStartResponse(BaseModel):
    session_id: str
    session_code: str
    ws_url: str
    status: str


class AnswerSubmit(BaseModel):
    quiz_id: str
    selected_option: str  # A, B, C, D
    response_time_ms: int


class AnswerResponse(BaseModel):
    is_correct: bool
    correct_option: str
    explanation: str | None = None
