from collections import defaultdict

from fastapi import APIRouter, Depends, HTTPException, status

from app.core.dependencies import get_current_user
from app.db.supabase import get_supabase
from app.models.dashboard import (
    AdminDashboard,
    AtRiskStudent,
    InstructorDashboard,
    InstructorSummary,
    PlatformStats,
    RecentSession,
)
from app.services.analysis_service import calculate_instructor_score

router = APIRouter(prefix="/dashboard", tags=["dashboard"])


# ──────────────────────────────────────────────
# GET /dashboard/instructor
# ──────────────────────────────────────────────

@router.get("/instructor", response_model=InstructorDashboard)
def instructor_dashboard(current_user: dict = Depends(get_current_user)):
    if current_user.get("role") not in ("instructor", "admin"):
        raise HTTPException(status_code=status.HTTP_403_FORBIDDEN, detail="강사 권한이 필요합니다")

    instructor_id = current_user["sub"]
    supabase = get_supabase()

    sessions_row = (
        supabase.table("sessions")
        .select("id, session_code, status, created_at")
        .eq("instructor_id", instructor_id)
        .order("created_at", desc=True)
        .execute()
    )
    sessions = sessions_row.data or []

    if not sessions:
        return InstructorDashboard(
            total_sessions=0,
            avg_participation_rate=0,
            avg_correct_rate=0,
            quality_score=0,
            recent_sessions=[],
        )

    session_ids = [s["id"] for s in sessions]

    answers_row = (
        supabase.table("answers")
        .select("session_id, user_id, is_correct")
        .in_("session_id", session_ids)
        .execute()
    )
    answers = answers_row.data or []

    # session_id별 집계
    session_answers: dict[str, list[dict]] = defaultdict(list)
    for a in answers:
        session_answers[a["session_id"]].append(a)

    participation_counts: list[float] = []
    correct_rates: list[float] = []
    for s in sessions:
        ans = session_answers[s["id"]]
        if ans:
            participation_counts.append(len({a["user_id"] for a in ans}))
            correct_rates.append(sum(1 for a in ans if a["is_correct"]) / len(ans) * 100)

    avg_participation = round(sum(participation_counts) / len(participation_counts), 1) if participation_counts else 0.0
    avg_correct = round(sum(correct_rates) / len(correct_rates), 1) if correct_rates else 0.0
    quality_score = calculate_instructor_score(instructor_id)

    recent_sessions = [
        RecentSession(
            session_id=s["id"],
            session_code=s["session_code"],
            status=s["status"],
            created_at=s["created_at"],
            participant_count=len({a["user_id"] for a in session_answers[s["id"]]}),
            correct_rate=round(
                sum(1 for a in session_answers[s["id"]] if a["is_correct"]) / len(session_answers[s["id"]]) * 100,
                1,
            ) if session_answers[s["id"]] else 0.0,
        )
        for s in sessions
        if s["status"] == "ended"
    ][:5]

    return InstructorDashboard(
        total_sessions=len(sessions),
        avg_participation_rate=avg_participation,
        avg_correct_rate=avg_correct,
        quality_score=quality_score,
        recent_sessions=recent_sessions,
    )


# ──────────────────────────────────────────────
# GET /dashboard/admin
# ──────────────────────────────────────────────

@router.get("/admin", response_model=AdminDashboard)
def admin_dashboard(current_user: dict = Depends(get_current_user)):
    if current_user.get("role") != "admin":
        raise HTTPException(status_code=status.HTTP_403_FORBIDDEN, detail="관리자 권한이 필요합니다")

    supabase = get_supabase()

    # 플랫폼 전체 집계
    users_row = supabase.table("users").select("id, role").execute()
    users = users_row.data or []

    sessions_row = supabase.table("sessions").select("id, instructor_id").execute()
    all_sessions = sessions_row.data or []

    answers_row = supabase.table("answers").select("user_id, is_correct").execute()
    all_answers = answers_row.data or []

    avg_correct = (
        round(sum(1 for a in all_answers if a["is_correct"]) / len(all_answers) * 100, 1)
        if all_answers else 0.0
    )

    platform = PlatformStats(
        total_users=len(users),
        total_sessions=len(all_sessions),
        total_answers=len(all_answers),
        avg_correct_rate=avg_correct,
    )

    # 강사별 quality_score
    instructors_data = [u for u in users if u["role"] == "instructor"]
    instructor_ids = [u["id"] for u in instructors_data]

    # 이름/이메일 조회
    if instructor_ids:
        instructor_detail_row = (
            supabase.table("users")
            .select("id, name, email")
            .in_("id", instructor_ids)
            .execute()
        )
        detail_map = {u["id"]: u for u in (instructor_detail_row.data or [])}
    else:
        detail_map = {}

    session_count_map: dict[str, int] = defaultdict(int)
    for s in all_sessions:
        session_count_map[s["instructor_id"]] += 1

    instructors = [
        InstructorSummary(
            instructor_id=iid,
            name=detail_map.get(iid, {}).get("name", ""),
            email=detail_map.get(iid, {}).get("email", ""),
            total_sessions=session_count_map[iid],
            quality_score=calculate_instructor_score(iid),
        )
        for iid in instructor_ids
    ]
    instructors.sort(key=lambda x: x.quality_score, reverse=True)

    # at_risk_students: 전체 정답률 < 40%, 최소 3문제 이상 답변한 학생
    student_answers: dict[str, list[dict]] = defaultdict(list)
    for a in all_answers:
        student_answers[a["user_id"]].append(a)

    student_ids = [u["id"] for u in users if u["role"] == "student"]
    at_risk_ids = [
        uid for uid in student_ids
        if len(student_answers[uid]) >= 3
        and sum(1 for a in student_answers[uid] if a["is_correct"]) / len(student_answers[uid]) < 0.4
    ]

    at_risk_students: list[AtRiskStudent] = []
    if at_risk_ids:
        at_risk_detail_row = (
            supabase.table("users")
            .select("id, name, email")
            .in_("id", at_risk_ids)
            .execute()
        )
        for u in (at_risk_detail_row.data or []):
            ans = student_answers[u["id"]]
            at_risk_students.append(
                AtRiskStudent(
                    user_id=u["id"],
                    name=u["name"],
                    email=u["email"],
                    overall_correct_rate=round(
                        sum(1 for a in ans if a["is_correct"]) / len(ans) * 100, 1
                    ),
                    total_answers=len(ans),
                )
            )
        at_risk_students.sort(key=lambda x: x.overall_correct_rate)

    return AdminDashboard(
        platform=platform,
        instructors=instructors,
        at_risk_students=at_risk_students,
    )
