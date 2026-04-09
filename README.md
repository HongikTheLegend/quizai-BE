# quizai-BE
KIT 공모전 &lt;quizai> BE 레포지토리입니다.

## 📌 프로젝트 개요

강의록(PDF/TXT)을 업로드하면 **Claude AI**가 자동으로 퀴즈를 생성하고,

강의 중 실시간으로 수강생에게 배포해 학습 참여도와 이해도를 정량적으로 분석합니다.

| 대상 | 페인 포인트 | 해결 방법 |
| --- | --- | --- |
| 교강사 | 학생 이해도를 실시간으로 알 수 없음 | 퀴즈 결과 즉시 시각화 |
| 수강생 | 질문하기 어렵고 고립감 | 퀴즈 참여로 능동적 학습 유도 |
| 운영자 | 강의 품질 정량 데이터 없음 | AI 기반 강사 평가 + 이탈 위험 감지 |

---

## 🛠️ 기술 스택

| 영역 | 기술 |
| --- | --- |
| Language | Python 3.11 |
| Framework | FastAPI + Uvicorn |
| Database | Supabase (PostgreSQL) |
| AI | Anthropic Claude API (claude-sonnet-4-5) |
| 인증 | JWT (python-jose + passlib bcrypt) |
| 실시간 | WebSocket (FastAPI 내장) |
| 배포 | Render |

---

## 🚀 서비스 핵심 플로우

```
① 강의록 업로드 (PDF/TXT)
② Claude API → 객관식 퀴즈 자동 생성
③ 강사가 [퀴즈 시작] 클릭
④ WebSocket으로 수강생 화면에 실시간 배포
⑤ 수강생 답변 → 즉시 정오답 피드백
⑥ 강사 화면에 이해도 분포 실시간 표시
⑦ 세션 종료 후 운영자 대시보드에 데이터 누적
```

---

## 📁 프로젝트 구조

```
quizai-BE/
├── app/
│   ├── main.py                  # FastAPI 앱 진입점, CORS 설정
│   ├── core/
│   │   ├── config.py            # 환경변수 로드
│   │   ├── security.py          # JWT 생성/검증
│   │   └── dependencies.py      # 공통 의존성 (get_current_user)
│   ├── db/
│   │   └── supabase.py          # Supabase 클라이언트
│   ├── models/                  # Pydantic 모델
│   ├── routers/                 # API 라우터
│   │   ├── auth.py              # 인증
│   │   ├── lectures.py          # 강의록 업로드
│   │   ├── quizzes.py           # 퀴즈 생성
│   │   ├── sessions.py          # 세션 관리
│   │   ├── websocket.py         # 실시간 WebSocket
│   │   └── dashboard.py         # 대시보드
│   ├── services/
│   │   ├── claude_service.py    # Claude API 연동
│   │   ├── session_service.py   # 세션 비즈니스 로직
│   │   └── analysis_service.py  # 이해도 분류, 강사 평가
│   └── websocket/
│       └── manager.py           # ConnectionManager
├── .env.example
├── requirements.txt
└── CLAUDE.md
```

---

## ⚙️ 로컬 실행 방법

### 1. 레포지토리 클론

```bash
git clone https://github.com/HongikTheLegend/quizai-BE.git
cd quizai-BE
```

### 2. 가상환경 세팅

```bash
python -m venv venv
source venv/bin/activate  # Mac/Linux
venv\Scripts\activate     # Windows
```

### 3. 패키지 설치

```bash
pip install -r requirements.txt
```

### 4. 환경변수 설정

```bash
cp .env.example .env
```

.env 파일을 열어서 아래 값을 채워주세요:

```
ANTHROPIC_API_KEY=sk-ant-...
SUPABASE_URL=https://프로젝트ID.supabase.co
SUPABASE_KEY=eyJ...
JWT_SECRET=랜덤한-비밀키
FRONTEND_URL=http://localhost:3000
```

### 5. 서버 실행

```bash
python -m uvicorn app.main:app --reload
```

### 6. API 문서 확인

```
http://localhost:8000/docs
```

---

## 📡 주요 API 목록

| 메서드 | 엔드포인트 | 설명 | 인증 |
| --- | --- | --- | --- |
| POST | /auth/register | 회원가입 | ❌ |
| POST | /auth/login | 로그인 | ❌ |
| POST | /lectures/upload | 강의록 업로드 | ✅ |
| POST | /quizzes/generate | AI 퀴즈 자동 생성 | ✅ |
| POST | /sessions/start | 퀴즈 세션 시작 | ✅ |
| WS | /sessions/{id}/join | 실시간 참여 | ✅ |
| POST | /sessions/{id}/answer | 답변 제출 | ✅ |
| GET | /sessions/{id}/result | 세션 결과 조회 | ✅ |
| GET | /dashboard/instructor | 강사 통계 | ✅ |
| GET | /dashboard/admin | 운영자 통계 | ✅ |

---

## 🗄️ DB 테이블 구조

```sql
users        -- 사용자 (강사/수강생/운영자)
lectures     -- 강의록
quizzes      -- 생성된 퀴즈
quiz_sets    -- 퀴즈 세트
sessions     -- 퀴즈 세션
answers      -- 수강생 답변
```

---

## 🌐 배포

- 백엔드: https://quizai-api.onrender.com
- 프론트엔드: https://quizai.vercel.app
- API 문서: https://quizai-api.onrender.com/docs

---

## 🔐 환경변수 목록

| 변수명 | 설명 | 필수 |
| --- | --- | --- |
| ANTHROPIC_API_KEY | Claude API 키 | ✅ |
| SUPABASE_URL | Supabase 프로젝트 URL | ✅ |
| SUPABASE_KEY | Supabase anon 키 | ✅ |
| JWT_SECRET | JWT 서명 비밀키 | ✅ |
| FRONTEND_URL | CORS 허용 프론트 URL | ✅ |

> ⚠️ .env 파일은 절대 GitHub에 커밋하지 마세요!
> 

---

## 👥 팀 구성

| 역할 | 담당 |
| --- | --- |
| 기획 | 서비스 플로우, 와이어프레임, AI 리포트 |
| 프론트엔드 | React (Next.js), Vercel 배포 |
| 백엔드 | FastAPI, Claude API 연동, Render 배포 |

---

## 📄 관련 레포지토리

- 프론트엔드: https://github.com/HongikTheLegend/quizai-FE
