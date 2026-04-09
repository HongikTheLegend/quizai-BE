from pydantic import BaseModel


class LectureUploadResponse(BaseModel):
    lecture_id: str
    title: str
    text_length: int
    created_at: str


class LectureResponse(BaseModel):
    id: str
    title: str
    instructor_id: str
    text_length: int
    created_at: str
