from collections import defaultdict

from app.db.supabase import get_supabase


def _grade(correct: int, total: int) -> str:
    if total == 0:
        return "needs_review"
    rate = correct / total * 100
    if rate >= 70:
        return "excellent"
    if rate >= 50:
        return "needs_practice"
    return "needs_review"


def get_my_quiz_results(user_id: str) -> list[dict]:
    supabase = get_supabase()

    answers_row = (
        supabase.table("answers")
        .select("session_id, is_correct")
        .eq("user_id", user_id)
        .execute()
    )
    answers = answers_row.data or []

    if not answers:
        return []

    # session_id별 정답/전체 집계
    counts: dict[str, dict] = defaultdict(lambda: {"correct": 0, "total": 0})
    for a in answers:
        sid = a["session_id"]
        counts[sid]["total"] += 1
        if a["is_correct"]:
            counts[sid]["correct"] += 1

    session_ids = list(counts.keys())

    sessions_row = (
        supabase.table("sessions")
        .select("id, title, attended_at")
        .in_("id", session_ids)
        .execute()
    )
    session_map = {s["id"]: s for s in (sessions_row.data or [])}

    results = []
    for sid, cnt in counts.items():
        session = session_map.get(sid, {})
        results.append({
            "session_id": sid,
            "title": session.get("title"),
            "attended_at": session.get("attended_at"),
            "my_score": cnt["correct"],
            "grade": _grade(cnt["correct"], cnt["total"]),
        })

    return results
