from pydantic import BaseModel


class RecentSession(BaseModel):
    session_id: str
    session_code: str
    status: str
    created_at: str
    participant_count: int
    correct_rate: float


class InstructorDashboard(BaseModel):
    total_sessions: int
    avg_participation_rate: float
    avg_correct_rate: float
    quality_score: float
    recent_sessions: list[RecentSession]


class PlatformStats(BaseModel):
    total_users: int
    total_sessions: int
    total_answers: int
    avg_correct_rate: float


class InstructorSummary(BaseModel):
    instructor_id: str
    name: str
    email: str
    total_sessions: int
    quality_score: float


class AtRiskStudent(BaseModel):
    user_id: str
    name: str
    email: str
    overall_correct_rate: float
    total_answers: int


class AdminDashboard(BaseModel):
    platform: PlatformStats
    instructors: list[InstructorSummary]
    at_risk_students: list[AtRiskStudent]


class StudentGrade(BaseModel):
    student_id: str
    nickname: str
    score: float   # 정답률 (0~100)
    grade: str     # excellent | needs_practice | needs_review


class SessionResultResponse(BaseModel):
    session_id: str
    total_students: int
    avg_score: float
    grade_distribution: dict[str, int]
    weak_concepts: list[str]
    students: list[StudentGrade]
