# PROMPT_HISTORY.md — Claude Code 주요 프롬프트 기록

이 파일은 Claude Code에 입력한 주요 프롬프트와 그 결과를 기능별로 정리합니다.

---

## 1. WebSocket broadcast 버그 수정

**커밋:** `fix: WebSocket broadcast 예외 처리 추가 및 동시 disconnect 방어`

**프롬프트 요약:**
- `manager.py`에서 강사/학생이 같은 session_id로 connections 딕셔너리에 둘 다 등록되는지 확인
- `broadcast()` 함수가 올바른 session_id로 호출되는지 확인
- broadcast 시 몇 명에게 전송했는지 로그 출력

**발견된 문제:**
- `broadcast()`에서 하나의 소켓 전송 실패 시 예외 처리 없어 루프 중단
- `dict.values()` 직접 순회 → `disconnect` 동시 호출 시 `RuntimeError`

**적용된 수정:**
- `list(items())` 스냅샷으로 순회
- 각 `send_json`을 `try/except`로 감싸기
- `[WS] broadcast | session_id=... | 수신자 수=N / 전체=M | type=...` 로그 추가

---

## 2. WebSocket next_question 이벤트 처리

**커밋:** `fix: WebSocket next_question 이벤트 처리 및 문제 순서 관리 추가`

**프롬프트 요약:**
- 강사가 보내는 메시지 타입을 `quiz_start + quiz_id` → `next_question`으로 변경
- 세션별 현재 문제 인덱스를 메모리(manager.py)에서 관리
- `next_question` 수신 시 자동으로 다음 문제 조회 후 브로드캐스트

**적용된 수정:**
- `manager.py`: `question_index` dict 추가, `advance_question()` 메서드
- `websocket.py`: `_fetch_question_by_index(index)` 함수로 교체, `question_index` / `question_total` payload 추가

---

## 3. 세션 결과 students 배열 및 대시보드 필터링

**커밋:** `fix: 세션 결과 students 배열 및 대시보드 ended 세션만 표시`

**프롬프트 요약:**
- `GET /sessions/{id}/result` 응답에서 `total_students > 0`인데 `students` 배열이 비어있는 문제
- `GET /dashboard/instructor`에서 `waiting` 상태 세션 제외, `ended`만 포함

**발견된 문제:**
- `StudentGrade` 모델에 `student_id`, `nickname`, `score` 필드 없음
- Claude 프롬프트가 한국어 grade(`우수`, `응용부족`) 반환 → 프론트 기대값과 불일치
- `recent_sessions[:5]`에 status 필터 없음

**적용된 수정:**
- `StudentGrade`: `student_id`, `nickname`, `score`, `grade` 필드로 재정의
- `SessionResultResponse`: `total_students`, `avg_score` 추가
- Claude 프롬프트 grade 키를 `excellent` / `needs_practice` / `needs_review`로 통일
- `classify_students()`: users 테이블에서 nickname 조회, score 직접 계산
- `recent_sessions` 빌드 시 `s["status"] == "ended"` 조건 추가

---

## 4. answers 저장 실패 디버깅

**커밋:** `fix: answers 저장 실패 시 500 에러 반환 및 로그 추가`

**프롬프트 요약:**
- `[answer] saved` 로그가 Render에 없음
- `submit_answer()` insert 결과 미검증 문제 확인
- WebSocket / REST 두 경로 중 어느 쪽으로 저장되는지 확인

**발견된 문제:**
- `supabase.table("answers").insert(...).execute()` 결과를 변수에 저장하지 않아 silent fail 가능
- RLS 정책으로 insert 차단 시 예외 없이 빈 data 반환

**적용된 수정:**
- `insert_result` 변수에 저장 후 `insert_result.data` 비어있으면 500 에러
- `[answer] saved` / `[answer] insert 실패` 로그 추가
- `_fetch_session_data()`에 `[classify] answers 조회 | 총 답변 수=N` 로그 추가

---

## 5. selected_option 숫자 인덱스 처리

**커밋:** `fix: submit_answer selected_option 숫자→문자 변환 및 response_time_ms 선택값 처리`

**프롬프트 요약:**
- 프론트가 `selected_option`을 숫자(0=A, 1=B, 2=C, 3=D)로 전송
- `response_time_ms` 없이 전송

**발견된 문제:**
- `selected_option = 0` (int)이 오면 `0.upper()` → `AttributeError` → except에 잡혀 DB 저장 안 됨

**적용된 수정:**
- `websocket.py`: `_normalize_option(raw)` 헬퍼 추가 — int(0~3) → "A"~"D", str → 대문자
- `session_service.py`: `isinstance(selected_option, int)` 타입 가드 추가

---

## 6. 학생별 문항 정오답 배열 추가

**커밋:** `feat: 세션 결과에 학생별 문항 정오답 배열 추가`

**프롬프트 요약:**
- `GET /sessions/{id}/result` 응답의 각 학생 객체에 `answers` 배열 포함
- `selected_option`은 문자("A"~"D") → 숫자(0~3)로 변환하여 반환

**적용된 수정:**
- `analysis_service.py`: `_OPTION_TO_INDEX` 상수 추가, `_aggregate_by_student()`에 `answers` 배열 구성
- `classify_students()`: `answers_map` 빌드 후 학생 객체에 합산
- `models/dashboard.py`: `StudentAnswer` 모델 신설, `StudentGrade`에 `answers: list[StudentAnswer] = []` 추가
