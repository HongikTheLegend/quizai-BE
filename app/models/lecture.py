from pydantic import BaseModel


class LectureBase(BaseModel):
    title: str


class LectureCreate(LectureBase):
    pass


class LectureResponse(LectureBase):
    id: str
    instructor_id: str
    content: str | None = None
    created_at: str

    class Config:
        from_attributes = True
