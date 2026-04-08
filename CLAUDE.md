# QuizAI Backend

## 프로젝트 개요
FastAPI 기반 AI 교육 퀴즈 플랫폼 백엔드.
강의록 업로드 → Claude API 퀴즈 생성 → WebSocket 실시간 세션 → 학생 이해도 분석
마감: 2026-04-13 / 팀: 백엔드(나) + 프론트엔드 + 기획

## 기술 스택
- Python 3.11 / FastAPI / Uvicorn
- Supabase (PostgreSQL)
- Anthropic Claude API (claude-sonnet-4-5)
- JWT 인증 (python-jose + passlib bcrypt)
- WebSocket (FastAPI 내장)
- 배포: Render

## 핵심 규칙
- 모든 환경변수는 .env에서만 로드, 절대 하드코딩 금지
- .env 파일은 절대 읽거나 수정하지 말 것. .env.example만 참고
- 라우터는 얇게 유지, 비즈니스 로직은 services/에만 작성
- WebSocket 연결 관리는 websocket/manager.py에 집중
- 모든 응답은 Pydantic 모델로 타입 명시

## 개발 우선순위 (MVP)
1. 프로젝트 구조 + 환경 세팅
2. auth (register/login + JWT)
3. lectures (upload + 텍스트 추출)
4. quizzes (Claude API 퀴즈 생성) ← 핵심
5. sessions (start + WebSocket + answer) ← 핵심
6. sessions/result (이해도 분류)
7. dashboard (instructor + admin)

## Base URL
- 로컬: http://localhost:8000
- 배포: https://quizai-api.onrender.com
- 프론트: https://quizai.vercel.app
