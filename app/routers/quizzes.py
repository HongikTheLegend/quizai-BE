from fastapi import APIRouter

router = APIRouter(prefix="/quizzes", tags=["quizzes"])

# POST /quizzes/generate/{lecture_id}  — Claude API로 퀴즈 생성
# GET  /quizzes/{lecture_id}           — 강의록 퀴즈 조회
# GET  /quizzes/question/{quiz_id}     — 퀴즈 문항 목록
