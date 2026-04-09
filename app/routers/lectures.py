from fastapi import APIRouter, Depends, Form, HTTPException, UploadFile, status

from app.core.dependencies import get_current_user
from app.db.supabase import get_supabase
from app.models.lecture import LectureResponse, LectureUploadResponse
from app.services.lecture_service import extract_text

router = APIRouter(prefix="/lectures", tags=["lectures"])

ALLOWED_EXTENSIONS = {".pdf", ".txt", ".docx"}
MAX_FILE_SIZE = 10 * 1024 * 1024  # 10MB


@router.post("/upload", response_model=LectureUploadResponse, status_code=status.HTTP_201_CREATED)
async def upload_lecture(
    file: UploadFile,
    title: str = Form(...),
    payload: dict = Depends(get_current_user),
):
    filename = (file.filename or "").lower()
    if not any(filename.endswith(ext) for ext in ALLOWED_EXTENSIONS):
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Unsupported file type. Use PDF, TXT, or DOCX.",
        )

    content = await file.read()
    if len(content) > MAX_FILE_SIZE:
        raise HTTPException(
            status_code=status.HTTP_413_REQUEST_ENTITY_TOO_LARGE,
            detail="File too large. Maximum size is 10MB.",
        )

    text = extract_text(file, content)
    if not text.strip():
        raise HTTPException(
            status_code=status.HTTP_422_UNPROCESSABLE_ENTITY,
            detail="Could not extract text from file.",
        )

    db = get_supabase()
    row = (
        db.table("lectures")
        .insert(
            {
                "instructor_id": payload["sub"],
                "title": title,
                "content": text,
                "text_length": len(text),
            }
        )
        .execute()
    )

    data = row.data[0]
    return LectureUploadResponse(
        lecture_id=data["id"],
        title=data["title"],
        text_length=data["text_length"],
        created_at=data["created_at"],
    )


@router.get("", response_model=list[LectureResponse])
def get_lectures(payload: dict = Depends(get_current_user)):
    db = get_supabase()
    rows = (
        db.table("lectures")
        .select("id, title, instructor_id, text_length, created_at")
        .eq("instructor_id", payload["sub"])
        .order("created_at", desc=True)
        .execute()
    )

    return [
        LectureResponse(
            id=r["id"],
            title=r["title"],
            instructor_id=r["instructor_id"],
            text_length=r["text_length"],
            created_at=r["created_at"],
        )
        for r in rows.data
    ]
