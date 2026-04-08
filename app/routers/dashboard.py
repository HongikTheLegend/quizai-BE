from fastapi import APIRouter

router = APIRouter(prefix="/dashboard", tags=["dashboard"])

# GET /dashboard/instructor         — 강사: 강의별 학생 이해도 현황
# GET /dashboard/instructor/{lecture_id}/students  — 강의별 학생 결과 목록
# GET /dashboard/admin              — 관리자: 전체 통계
