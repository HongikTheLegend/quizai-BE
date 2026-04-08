from fastapi import APIRouter

router = APIRouter(prefix="/lectures", tags=["lectures"])

# POST   /lectures          — 강의록 업로드 (multipart/form-data)
# GET    /lectures          — 내 강의록 목록
# GET    /lectures/{id}     — 강의록 상세
# DELETE /lectures/{id}     — 강의록 삭제
