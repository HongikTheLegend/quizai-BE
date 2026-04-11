from fastapi import APIRouter, Depends, HTTPException, Request, status

from app.core.dependencies import get_current_user
from app.db.supabase import get_supabase
from app.models.dashboard import SessionResultResponse, StudentGrade
from app.models.session import AnswerResponse, AnswerSubmit, SessionJoin, SessionJoinResponse, SessionStart, SessionStartResponse
from app.services.analysis_service import classify_students
from app.services.session_service import create_session, get_answer_stats, submit_answer
from app.websocket.manager import manager

router = APIRouter(prefix="/sessions", tags=["sessions"])


@router.post("/start", response_model=SessionStartResponse)
def start_session(
    body: SessionStart,
    request: Request,
    current_user: dict = Depends(get_current_user),
):
    session = create_session(body.quiz_set_id, current_user["sub"], body.time_limit)

    base = str(request.base_url).rstrip("/")
    ws_base = base.replace("http://", "ws://").replace("https://", "wss://")
    ws_url = f"{ws_base}/sessions/{session['id']}/join"

    return SessionStartResponse(
        session_id=session["id"],
        session_code=session["session_code"],
        ws_url=ws_url,
        status=session["status"],
    )


@router.post("/join", response_model=SessionJoinResponse)
def join_session(body: SessionJoin, request: Request):
    row = (
        get_supabase()
        .table("sessions")
        .select("id")
        .eq("session_code", body.session_code.upper())
        .single()
        .execute()
    )
    if not row.data:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Session not found")

    session_id = row.data["id"]
    base = str(request.base_url).rstrip("/")
    ws_base = base.replace("http://", "ws://").replace("https://", "wss://")

    return SessionJoinResponse(
        session_id=session_id,
        ws_url=f"{ws_base}/sessions/{session_id}/join",
    )


@router.post("/{session_id}/answer", response_model=AnswerResponse)
async def answer(
    session_id: str,
    body: AnswerSubmit,
    current_user: dict = Depends(get_current_user),
):
    result = submit_answer(
        session_id,
        body.quiz_id,
        current_user["sub"],
        body.selected_option,
        body.response_time_ms,
    )

    total_students = manager.get_student_count(session_id)
    stats = get_answer_stats(session_id, body.quiz_id, total_students)
    await manager.send_to_instructors(session_id, {
        "type": "answer_update",
        "quiz_id": body.quiz_id,
        "answer_count": stats["answer_count"],
        "response_rate": stats["response_rate"],
    })

    return AnswerResponse(**result)


@router.get("/{session_id}/result", response_model=SessionResultResponse)
def session_result(
    session_id: str,
    current_user: dict = Depends(get_current_user),
):
    row = get_supabase().table("sessions").select("instructor_id").eq("id", session_id).single().execute()
    if not row.data:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="세션을 찾을 수 없습니다")
    if current_user.get("role") not in ("admin",) and row.data["instructor_id"] != current_user["sub"]:
        raise HTTPException(status_code=status.HTTP_403_FORBIDDEN, detail="권한이 없습니다")

    result = classify_students(session_id)
    return SessionResultResponse(
        session_id=session_id,
        grade_distribution=result["grade_distribution"],
        weak_concepts=result["weak_concepts"],
        students=[StudentGrade(**s) for s in result["students"]],
    )
