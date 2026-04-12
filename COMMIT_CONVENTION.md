# COMMIT_CONVENTION.md — 커밋 메시지 규칙

## 형식

```
<type>: <제목>
```

- 제목은 한국어 사용
- 마침표 없이 작성
- 현재형 동사로 시작 (추가, 수정, 제거 등)

---

## 타입 목록

| 타입 | 설명 | 예시 |
|------|------|------|
| `feat` | 새로운 기능 추가 | `feat: WebSocket next_question 이벤트 처리 추가` |
| `fix` | 버그 수정 | `fix: broadcast 예외 처리 추가` |
| `chore` | 빌드, 패키지, 설정 변경 (코드 변경 없음) | `chore: requirements.txt 의존성 업데이트` |
| `docs` | 문서 추가/수정 | `docs: BACKEND_HANDOFF.md 작성` |
| `refactor` | 기능 변경 없는 코드 구조 개선 | `refactor: session_service 함수 분리` |
| `test` | 테스트 추가/수정 | `test: submit_answer 단위 테스트 추가` |
| `style` | 포맷팅, 공백 등 스타일 변경 | `style: 불필요한 공백 제거` |
| `perf` | 성능 개선 | `perf: answers 조회 쿼리 최적화` |

---

## 예시

```
feat: GET /sessions/{id}/result 학생별 문항 정오답 배열 추가
fix: WebSocket broadcast 예외 처리 추가 및 동시 disconnect 방어
fix: submit_answer selected_option 숫자→문자 변환 처리
fix: 세션 결과 students 배열 및 대시보드 ended 세션만 표시
chore: .env.example 환경변수 목록 업데이트
docs: AGENTS.md 및 COMMIT_CONVENTION.md 작성
```

---

## 규칙

- 하나의 커밋에는 하나의 논리적 변경만 포함
- 여러 파일을 수정했더라도 같은 목적이면 하나의 커밋으로
- `fix`와 `feat`를 혼용하지 말 것 — 버그 수정은 `fix`, 새 기능은 `feat`
- 배포 전 `chore: Render 배포 설정 확인` 등 배포 관련 커밋은 별도로
