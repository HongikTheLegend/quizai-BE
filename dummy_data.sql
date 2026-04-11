-- ============================================================
-- QuizAI 더미 데이터
-- 비밀번호: test1234 (bcrypt)
-- 실행 순서: 삭제(역방향 FK) → 삽입
-- ============================================================

-- ──────────────────────────────────────────────
-- 1. 기존 데이터 삭제 (FK 역순)
-- ──────────────────────────────────────────────
DELETE FROM answers;
DELETE FROM sessions;
DELETE FROM quizzes;
DELETE FROM lectures;
DELETE FROM users;

-- ──────────────────────────────────────────────
-- 2. users (강사 4명 + 수강생 20명 + 운영자 3명)
-- ──────────────────────────────────────────────
INSERT INTO users (id, email, password_hash, name, role) VALUES

-- 강사
('0e0e513c-cb88-4aa4-bcc0-488d3435d0f3', 'instructor1@test.com', '$2b$12$hxDBI6tfE0FvxpdcdmdfMeYFfjWxz.SZCVFvts16mOkBfsDuvJvC.', '김민준', 'instructor'),
('b622adcc-b247-45b5-9e4c-980948190423', 'instructor2@test.com', '$2b$12$hxDBI6tfE0FvxpdcdmdfMeYFfjWxz.SZCVFvts16mOkBfsDuvJvC.', '이수진', 'instructor'),
('06a766d1-8e82-4631-89bd-68a956d6fb26', 'instructor3@test.com', '$2b$12$hxDBI6tfE0FvxpdcdmdfMeYFfjWxz.SZCVFvts16mOkBfsDuvJvC.', '박지호', 'instructor'),
('f73909bc-da9e-4a8f-ab21-b4fe6a097c10', 'instructor4@test.com', '$2b$12$hxDBI6tfE0FvxpdcdmdfMeYFfjWxz.SZCVFvts16mOkBfsDuvJvC.', '최유리', 'instructor'),

-- 수강생
('7714e381-4cd3-4e9c-8368-3ab57ed436de', 'student1@test.com',  '$2b$12$hxDBI6tfE0FvxpdcdmdfMeYFfjWxz.SZCVFvts16mOkBfsDuvJvC.', '학생1',  'student'),
('5398f3a5-36f5-4643-b44c-04c2a3cd542c', 'student2@test.com',  '$2b$12$hxDBI6tfE0FvxpdcdmdfMeYFfjWxz.SZCVFvts16mOkBfsDuvJvC.', '학생2',  'student'),
('c77287ad-4858-40b5-ae47-07d481b5ba28', 'student3@test.com',  '$2b$12$hxDBI6tfE0FvxpdcdmdfMeYFfjWxz.SZCVFvts16mOkBfsDuvJvC.', '학생3',  'student'),
('f379cc84-5936-4511-b61d-75a947929d84', 'student4@test.com',  '$2b$12$hxDBI6tfE0FvxpdcdmdfMeYFfjWxz.SZCVFvts16mOkBfsDuvJvC.', '학생4',  'student'),
('a7696bd1-9fd8-43af-b580-a164733a65dc', 'student5@test.com',  '$2b$12$hxDBI6tfE0FvxpdcdmdfMeYFfjWxz.SZCVFvts16mOkBfsDuvJvC.', '학생5',  'student'),
('cef3fb12-74ee-4d2d-8d5d-146e87d83b48', 'student6@test.com',  '$2b$12$hxDBI6tfE0FvxpdcdmdfMeYFfjWxz.SZCVFvts16mOkBfsDuvJvC.', '학생6',  'student'),
('e37ffc43-82de-4d9e-a143-2ad548cb6f2d', 'student7@test.com',  '$2b$12$hxDBI6tfE0FvxpdcdmdfMeYFfjWxz.SZCVFvts16mOkBfsDuvJvC.', '학생7',  'student'),
('b2ed5cb9-0e31-4929-9774-d1dc3be100a1', 'student8@test.com',  '$2b$12$hxDBI6tfE0FvxpdcdmdfMeYFfjWxz.SZCVFvts16mOkBfsDuvJvC.', '학생8',  'student'),
('744d8720-213d-4a28-bac2-4099cc9cb046', 'student9@test.com',  '$2b$12$hxDBI6tfE0FvxpdcdmdfMeYFfjWxz.SZCVFvts16mOkBfsDuvJvC.', '학생9',  'student'),
('14ca14a5-a14f-44b3-a508-23b39b44d3c5', 'student10@test.com', '$2b$12$hxDBI6tfE0FvxpdcdmdfMeYFfjWxz.SZCVFvts16mOkBfsDuvJvC.', '학생10', 'student'),
('f4c6b14f-6517-499f-8694-0b86ccc547a0', 'student11@test.com', '$2b$12$hxDBI6tfE0FvxpdcdmdfMeYFfjWxz.SZCVFvts16mOkBfsDuvJvC.', '학생11', 'student'),
('5bb9fb6a-586c-40ad-b63b-d224318a3f33', 'student12@test.com', '$2b$12$hxDBI6tfE0FvxpdcdmdfMeYFfjWxz.SZCVFvts16mOkBfsDuvJvC.', '학생12', 'student'),
('3558b5e4-d8cf-4f8e-9fdc-e03d06ea9687', 'student13@test.com', '$2b$12$hxDBI6tfE0FvxpdcdmdfMeYFfjWxz.SZCVFvts16mOkBfsDuvJvC.', '학생13', 'student'),
('52b9459f-ecb4-4e82-bc40-109ede361ab9', 'student14@test.com', '$2b$12$hxDBI6tfE0FvxpdcdmdfMeYFfjWxz.SZCVFvts16mOkBfsDuvJvC.', '학생14', 'student'),
('b22cc175-6817-4e93-b302-ab8ca87bc6f7', 'student15@test.com', '$2b$12$hxDBI6tfE0FvxpdcdmdfMeYFfjWxz.SZCVFvts16mOkBfsDuvJvC.', '학생15', 'student'),
('cb880339-8370-4957-810d-ea20d3a0e355', 'student16@test.com', '$2b$12$hxDBI6tfE0FvxpdcdmdfMeYFfjWxz.SZCVFvts16mOkBfsDuvJvC.', '학생16', 'student'),
('3a42d9ec-b574-47a8-8c53-0299dcec337a', 'student17@test.com', '$2b$12$hxDBI6tfE0FvxpdcdmdfMeYFfjWxz.SZCVFvts16mOkBfsDuvJvC.', '학생17', 'student'),
('7dd36739-30e4-4706-a32f-10f93d060fd4', 'student18@test.com', '$2b$12$hxDBI6tfE0FvxpdcdmdfMeYFfjWxz.SZCVFvts16mOkBfsDuvJvC.', '학생18', 'student'),
('36d10a08-0019-4af5-9e79-959996e0405b', 'student19@test.com', '$2b$12$hxDBI6tfE0FvxpdcdmdfMeYFfjWxz.SZCVFvts16mOkBfsDuvJvC.', '학생19', 'student'),
('1f8d4374-6b8b-417b-992a-ac57ad4a08f4', 'student20@test.com', '$2b$12$hxDBI6tfE0FvxpdcdmdfMeYFfjWxz.SZCVFvts16mOkBfsDuvJvC.', '학생20', 'student'),

-- 운영자
('c4b73ea7-4fc4-4144-b223-a907421efc90', 'admin1@test.com', '$2b$12$hxDBI6tfE0FvxpdcdmdfMeYFfjWxz.SZCVFvts16mOkBfsDuvJvC.', '운영자1', 'admin'),
('74b15af3-0e8c-4ef6-84a8-3c85d21ab74d', 'admin2@test.com', '$2b$12$hxDBI6tfE0FvxpdcdmdfMeYFfjWxz.SZCVFvts16mOkBfsDuvJvC.', '운영자2', 'admin'),
('075fa6e1-9aba-4ea8-bd40-1dec4026dc47', 'admin3@test.com', '$2b$12$hxDBI6tfE0FvxpdcdmdfMeYFfjWxz.SZCVFvts16mOkBfsDuvJvC.', '운영자3', 'admin');

-- ──────────────────────────────────────────────
-- 3. lectures (강사별 2~3개, 총 10개)
-- ──────────────────────────────────────────────
INSERT INTO lectures (id, instructor_id, title, content, text_length) VALUES

-- 김민준 (instructor1) - 3개
('2da6832d-26a1-4679-8010-8edebdcf5414', '0e0e513c-cb88-4aa4-bcc0-488d3435d0f3',
 '머신러닝 기초',
 '머신러닝은 데이터로부터 패턴을 학습하여 예측하는 기술입니다. 지도학습, 비지도학습, 강화학습으로 구분됩니다. 지도학습은 레이블이 있는 데이터로 분류와 회귀 문제를 풀고, 비지도학습은 레이블 없이 클러스터링과 차원축소를 수행합니다. 대표 알고리즘으로는 선형회귀, 결정트리, 랜덤포레스트, SVM 등이 있습니다.',
 200),
('29e12500-f8bc-44f3-8ad9-9355508df8ce', '0e0e513c-cb88-4aa4-bcc0-488d3435d0f3',
 '딥러닝 심화',
 '딥러닝은 다층 신경망을 이용하여 복잡한 패턴을 학습합니다. CNN은 이미지 분류에, RNN은 시퀀스 데이터에, Transformer는 자연어 처리에 주로 사용됩니다. 역전파 알고리즘과 경사하강법을 통해 가중치를 업데이트하며, 드롭아웃과 배치 정규화로 과적합을 방지합니다.',
 200),
('4caf0a17-4307-47d6-b84d-00a7826072db', '0e0e513c-cb88-4aa4-bcc0-488d3435d0f3',
 '자연어 처리 입문',
 '자연어 처리(NLP)는 컴퓨터가 인간의 언어를 이해하고 생성하는 기술입니다. 토큰화, 형태소 분석, 품사 태깅, 개체명 인식 등의 전처리 과정을 거칩니다. Word2Vec, BERT, GPT 등 임베딩 모델이 발전하면서 문맥 이해 능력이 크게 향상되었습니다.',
 200),

-- 이수진 (instructor2) - 3개
('1efbab46-3ad9-498d-9aa5-bf1b4235a52f', 'b622adcc-b247-45b5-9e4c-980948190423',
 'Python 입문',
 'Python은 간결한 문법과 풍부한 라이브러리로 초보자에게 적합한 언어입니다. 변수, 조건문, 반복문, 함수, 클래스 등의 기본 문법을 배웁니다. list, dict, tuple, set 등의 자료구조와 파일 입출력, 예외 처리도 핵심 개념입니다.',
 200),
('f497b12b-169d-4ec5-a275-a834430ca009', 'b622adcc-b247-45b5-9e4c-980948190423',
 '데이터 분석 with Pandas',
 'Pandas는 Python에서 데이터 분석을 위한 핵심 라이브러리입니다. DataFrame과 Series를 이용하여 데이터를 로드, 탐색, 정제합니다. groupby, merge, pivot_table 등으로 데이터를 집계하고, matplotlib/seaborn과 연계하여 시각화합니다.',
 200),
('3c74645c-fa62-45b7-8c32-aa2f7a6a2397', 'b622adcc-b247-45b5-9e4c-980948190423',
 '웹 개발 기초 (FastAPI)',
 'FastAPI는 Python 기반의 고성능 웹 프레임워크로 자동 문서화를 지원합니다. Path/Query/Body 파라미터, Pydantic 모델, 의존성 주입, JWT 인증을 활용합니다. 비동기(async/await)를 기본으로 지원하여 높은 처리량을 달성합니다.',
 200),

-- 박지호 (instructor3) - 2개
('dcc6dfbe-238b-48b0-80ba-0aa39d86c638', '06a766d1-8e82-4631-89bd-68a956d6fb26',
 '데이터베이스 설계',
 '관계형 데이터베이스는 테이블 간 관계를 외래키로 표현합니다. 정규화(1NF~3NF)를 통해 데이터 중복을 제거하고 무결성을 보장합니다. 인덱스는 검색 성능을 향상시키며, 트랜잭션은 ACID 속성으로 데이터 일관성을 유지합니다.',
 200),
('14670c51-57c1-4c0a-bb60-d7a482aca7e3', '06a766d1-8e82-4631-89bd-68a956d6fb26',
 '클라우드 컴퓨팅 개론',
 '클라우드 컴퓨팅은 IaaS, PaaS, SaaS로 구분됩니다. AWS, GCP, Azure가 주요 공급자이며 가상화 기술로 자원을 탄력적으로 제공합니다. 컨테이너(Docker)와 오케스트레이션(Kubernetes)이 현대 클라우드의 핵심 기술입니다.',
 200),

-- 최유리 (instructor4) - 2개
('e23d5ac7-b7bc-4bb2-b50a-ad652d509d92', 'f73909bc-da9e-4a8f-ab21-b4fe6a097c10',
 '알고리즘과 자료구조',
 '자료구조는 데이터를 효율적으로 저장하고 접근하는 방식입니다. 배열, 연결리스트, 스택, 큐, 트리, 그래프, 해시테이블을 학습합니다. 알고리즘의 시간복잡도는 Big-O 표기법으로 나타내며, 정렬·탐색·동적프로그래밍이 핵심 유형입니다.',
 200),
('8d1b526b-80d7-4d2e-8b56-71742e48d41e', 'f73909bc-da9e-4a8f-ab21-b4fe6a097c10',
 '컴퓨터 네트워크',
 '네트워크는 OSI 7계층 모델로 구조화됩니다. TCP/IP 프로토콜이 인터넷의 근간이며, HTTP/HTTPS는 웹 통신에 사용됩니다. DNS, DHCP, NAT, 방화벽 등 핵심 구성 요소와 소켓 프로그래밍 기초를 다룹니다.',
 200);

-- ──────────────────────────────────────────────
-- 4. quizzes (sessions FK 대응, 강의별 최소 1개)
--    questions 필드: 실제 Claude 생성 대신 샘플 데이터
-- ──────────────────────────────────────────────
INSERT INTO quizzes (id, lecture_id, instructor_id, questions) VALUES

-- instructor1 강의용
('28c70aad-3ade-47f1-9d4d-a67ced1407f8', '2da6832d-26a1-4679-8010-8edebdcf5414', '0e0e513c-cb88-4aa4-bcc0-488d3435d0f3',
 '[{"id":"e0bad897-00d9-40ec-8bbb-e8296720d674","question":"지도학습의 특징으로 옳은 것은?","options":[{"label":"A","text":"레이블 없이 학습"},{"label":"B","text":"레이블 있는 데이터로 학습"},{"label":"C","text":"보상 신호로 학습"},{"label":"D","text":"군집화만 수행"}],"answer":"B","explanation":"지도학습은 레이블이 있는 데이터로 분류·회귀 문제를 풉니다."},{"id":"f07f560d-fe8c-4da3-a5a0-a9c90ef0d06e","question":"랜덤포레스트는 어떤 알고리즘 계열인가?","options":[{"label":"A","text":"신경망"},{"label":"B","text":"앙상블"},{"label":"C","text":"클러스터링"},{"label":"D","text":"강화학습"}],"answer":"B","explanation":"랜덤포레스트는 여러 결정트리를 결합한 앙상블 알고리즘입니다."},{"id":"1fb3203a-37e1-4192-8a25-5a83bd8adc99","question":"비지도학습의 대표적인 작업은?","options":[{"label":"A","text":"분류"},{"label":"B","text":"회귀"},{"label":"C","text":"클러스터링"},{"label":"D","text":"강화"}],"answer":"C","explanation":"비지도학습은 레이블 없이 클러스터링·차원축소를 수행합니다."}]'),
('cba4218d-e454-41be-9ee6-2bab8152d88d', '29e12500-f8bc-44f3-8ad9-9355508df8ce', '0e0e513c-cb88-4aa4-bcc0-488d3435d0f3',
 '[{"id":"43b206a1-cc03-4bc5-a801-2b57f588063b","question":"CNN이 주로 활용되는 분야는?","options":[{"label":"A","text":"이미지 분류"},{"label":"B","text":"텍스트 분류"},{"label":"C","text":"강화학습"},{"label":"D","text":"추천 시스템"}],"answer":"A","explanation":"CNN은 합성곱 연산으로 이미지의 공간적 특징을 추출합니다."},{"id":"37c61f30-e82d-4842-8234-23002c0a56e9","question":"과적합 방지 기법이 아닌 것은?","options":[{"label":"A","text":"드롭아웃"},{"label":"B","text":"배치 정규화"},{"label":"C","text":"학습률 증가"},{"label":"D","text":"L2 정규화"}],"answer":"C","explanation":"학습률을 높이면 오히려 과적합이 심해질 수 있습니다."},{"id":"e4b7f6fd-4adf-4563-8022-4da2b8307893","question":"역전파 알고리즘의 목적은?","options":[{"label":"A","text":"데이터 정규화"},{"label":"B","text":"가중치 업데이트"},{"label":"C","text":"레이어 추가"},{"label":"D","text":"활성화 함수 선택"}],"answer":"B","explanation":"역전파는 손실 기울기를 역방향으로 전파하여 가중치를 업데이트합니다."}]'),

-- instructor2 강의용
('948d3c66-7617-47d6-8cc7-850e0a2a1a9e', '1efbab46-3ad9-498d-9aa5-bf1b4235a52f', 'b622adcc-b247-45b5-9e4c-980948190423',
 '[{"id":"q3a","question":"Python 리스트와 튜플의 차이는?","options":[{"label":"A","text":"튜플은 변경 가능"},{"label":"B","text":"리스트는 변경 가능"},{"label":"C","text":"차이 없음"},{"label":"D","text":"튜플은 정렬됨"}],"answer":"B","explanation":"리스트는 mutable, 튜플은 immutable입니다."}]'),
('ade3cc49-0d5c-4761-a98f-de45150be558', 'f497b12b-169d-4ec5-a275-a834430ca009', 'b622adcc-b247-45b5-9e4c-980948190423',
 '[{"id":"q4a","question":"Pandas DataFrame의 행 인덱싱에 사용하는 메서드는?","options":[{"label":"A","text":"iloc / loc"},{"label":"B","text":"get / set"},{"label":"C","text":"find / seek"},{"label":"D","text":"row / col"}],"answer":"A","explanation":"iloc은 정수 위치, loc은 레이블 기반 인덱싱입니다."}]'),

-- instructor3 강의용
('722a773c-315e-432d-97bf-7de7016084e9', 'dcc6dfbe-238b-48b0-80ba-0aa39d86c638', '06a766d1-8e82-4631-89bd-68a956d6fb26',
 '[{"id":"q5a","question":"데이터베이스 정규화의 목적은?","options":[{"label":"A","text":"데이터 중복 증가"},{"label":"B","text":"데이터 중복 제거"},{"label":"C","text":"인덱스 삭제"},{"label":"D","text":"쿼리 속도 저하"}],"answer":"B","explanation":"정규화는 데이터 중복을 제거하고 무결성을 보장합니다."}]'),
('476db780-ac29-4ca9-9e01-03dc00e836c9', '14670c51-57c1-4c0a-bb60-d7a482aca7e3', '06a766d1-8e82-4631-89bd-68a956d6fb26',
 '[{"id":"q6a","question":"IaaS에 해당하는 서비스는?","options":[{"label":"A","text":"Gmail"},{"label":"B","text":"AWS EC2"},{"label":"C","text":"Salesforce"},{"label":"D","text":"Google Docs"}],"answer":"B","explanation":"IaaS는 가상 서버·스토리지 등 인프라를 제공합니다."}]'),

-- instructor4 강의용
('42b97b6f-428a-40d7-8f98-c7b380467e53', 'e23d5ac7-b7bc-4bb2-b50a-ad652d509d92', 'f73909bc-da9e-4a8f-ab21-b4fe6a097c10',
 '[{"id":"q7a","question":"스택의 특성은?","options":[{"label":"A","text":"FIFO"},{"label":"B","text":"LIFO"},{"label":"C","text":"랜덤 접근"},{"label":"D","text":"이중 연결"}],"answer":"B","explanation":"스택은 Last In First Out 구조입니다."}]'),
('efa659db-dd45-4715-b89f-d9317c35e13d', '8d1b526b-80d7-4d2e-8b56-71742e48d41e', 'f73909bc-da9e-4a8f-ab21-b4fe6a097c10',
 '[{"id":"q8a","question":"TCP와 UDP의 가장 큰 차이는?","options":[{"label":"A","text":"속도"},{"label":"B","text":"연결 지향 여부"},{"label":"C","text":"포트 번호"},{"label":"D","text":"IP 버전"}],"answer":"B","explanation":"TCP는 연결 지향, UDP는 비연결 지향 프로토콜입니다."}]');

-- ──────────────────────────────────────────────
-- 5. sessions (강사별 2개씩 총 8개)
--    waiting 4개, active 2개, ended 2개
-- ──────────────────────────────────────────────
INSERT INTO sessions (id, quiz_set_id, instructor_id, session_code, time_limit, status, title, attended_at) VALUES

-- instructor1 (김민준): waiting, ended
('546f6bdd-49fe-418f-a723-1f9a39af7589', '28c70aad-3ade-47f1-9d4d-a67ced1407f8',
 '0e0e513c-cb88-4aa4-bcc0-488d3435d0f3', 'A1B2', 30, 'waiting', '머신러닝 기초 1회차', NULL),
('02e92a2a-58dd-47e5-a1e3-9a90bfd1830e', 'cba4218d-e454-41be-9ee6-2bab8152d88d',
 '0e0e513c-cb88-4aa4-bcc0-488d3435d0f3', 'C3D4', 30, 'ended',   '딥러닝 심화 1회차',   '2026-04-05T10:00:00Z'),

-- instructor2 (이수진): waiting, active
('e8bc0158-216e-4722-a1b1-36ee6629f352', '948d3c66-7617-47d6-8cc7-850e0a2a1a9e',
 'b622adcc-b247-45b5-9e4c-980948190423', 'E5F6', 30, 'waiting', 'Python 입문 1회차',          NULL),
('3f89a797-d593-446b-adc5-9c52e784562f', 'ade3cc49-0d5c-4761-a98f-de45150be558',
 'b622adcc-b247-45b5-9e4c-980948190423', 'G7H8', 30, 'active',  '데이터 분석 with Pandas 1회차', NULL),

-- instructor3 (박지호): waiting, active
('2cd5e19b-054e-427f-b19c-d5f6f21a7fbc', '722a773c-315e-432d-97bf-7de7016084e9',
 '06a766d1-8e82-4631-89bd-68a956d6fb26', 'I9J0', 30, 'waiting', '데이터베이스 설계 1회차', NULL),
('e39ae946-4e6b-4cd3-a747-887c75ed5339', '476db780-ac29-4ca9-9e01-03dc00e836c9',
 '06a766d1-8e82-4631-89bd-68a956d6fb26', 'K1L2', 30, 'active',  '클라우드 컴퓨팅 개론 1회차', NULL),

-- instructor4 (최유리): waiting, ended
('7b586858-187b-4943-8bb3-609db2773c60', '42b97b6f-428a-40d7-8f98-c7b380467e53',
 'f73909bc-da9e-4a8f-ab21-b4fe6a097c10', 'M3N4', 30, 'waiting', '알고리즘과 자료구조 1회차', NULL),
('cd89dbcc-aacd-4f59-9274-d450c47740dc', 'efa659db-dd45-4715-b89f-d9317c35e13d',
 'f73909bc-da9e-4a8f-ab21-b4fe6a097c10', 'O5P6', 30, 'ended',   '컴퓨터 네트워크 1회차',    '2026-04-07T14:00:00Z');

-- ──────────────────────────────────────────────
-- 6. answers (ended 세션 2개 × 학생 10명 × 퀴즈 3개 = 60개)
--
--    ended 세션:
--      C3D4 (02e92a2a): quiz1(e0bad897), quiz2(f07f560d), quiz3(1fb3203a)
--      O5P6 (cd89dbcc): quiz4(43b206a1), quiz5(37c61f30), quiz6(e4b7f6fd)
--
--    is_correct 패턴 (정답률 분포 반영):
--      학생1,5    : 우수 (3/3 정답)
--      학생2,3,4,8: 보통 (2/3 정답)
--      학생6,7,9,10: 취약 (1/3 정답)
-- ──────────────────────────────────────────────
INSERT INTO answers (id, session_id, quiz_id, user_id, selected_option, is_correct, response_time_ms) VALUES

-- ── C3D4 세션 (02e92a2a) ──

-- 학생1 (우수: T T T)
('7059c8a6-a272-4a8c-8e6a-133946873933', '02e92a2a-58dd-47e5-a1e3-9a90bfd1830e', 'e0bad897-00d9-40ec-8bbb-e8296720d674', '7714e381-4cd3-4e9c-8368-3ab57ed436de', 'B', true,  1200),
('ea0d9c7e-a505-4810-ba84-b49c4a8e3463', '02e92a2a-58dd-47e5-a1e3-9a90bfd1830e', 'f07f560d-fe8c-4da3-a5a0-a9c90ef0d06e', '7714e381-4cd3-4e9c-8368-3ab57ed436de', 'B', true,  1400),
('a98db0ea-6c49-4ecd-965b-cc26614c3ec2', '02e92a2a-58dd-47e5-a1e3-9a90bfd1830e', '1fb3203a-37e1-4192-8a25-5a83bd8adc99', '7714e381-4cd3-4e9c-8368-3ab57ed436de', 'C', true,  1100),

-- 학생2 (보통: T F T)
('75ed45f6-d292-40e9-8129-8646ced92785', '02e92a2a-58dd-47e5-a1e3-9a90bfd1830e', 'e0bad897-00d9-40ec-8bbb-e8296720d674', '5398f3a5-36f5-4643-b44c-04c2a3cd542c', 'B', true,  2100),
('31e1db23-84fb-421a-8895-32ab2dbf180c', '02e92a2a-58dd-47e5-a1e3-9a90bfd1830e', 'f07f560d-fe8c-4da3-a5a0-a9c90ef0d06e', '5398f3a5-36f5-4643-b44c-04c2a3cd542c', 'A', false, 3200),
('f5452070-7f72-4061-ac19-42607ce7dc1a', '02e92a2a-58dd-47e5-a1e3-9a90bfd1830e', '1fb3203a-37e1-4192-8a25-5a83bd8adc99', '5398f3a5-36f5-4643-b44c-04c2a3cd542c', 'C', true,  1800),

-- 학생3 (보통: F T T)
('08f45299-5255-4d18-8b76-f53ea1cee35a', '02e92a2a-58dd-47e5-a1e3-9a90bfd1830e', 'e0bad897-00d9-40ec-8bbb-e8296720d674', 'c77287ad-4858-40b5-ae47-07d481b5ba28', 'A', false, 2500),
('ceb77dc9-a6f9-4fa5-8af2-7e92682894ba', '02e92a2a-58dd-47e5-a1e3-9a90bfd1830e', 'f07f560d-fe8c-4da3-a5a0-a9c90ef0d06e', 'c77287ad-4858-40b5-ae47-07d481b5ba28', 'B', true,  1500),
('61fbdffb-7fa7-4397-a4a7-97d8950feb3c', '02e92a2a-58dd-47e5-a1e3-9a90bfd1830e', '1fb3203a-37e1-4192-8a25-5a83bd8adc99', 'c77287ad-4858-40b5-ae47-07d481b5ba28', 'C', true,  1300),

-- 학생4 (보통: T T F)
('1a577637-fddd-4d04-b9f1-46a74885c8ec', '02e92a2a-58dd-47e5-a1e3-9a90bfd1830e', 'e0bad897-00d9-40ec-8bbb-e8296720d674', 'f379cc84-5936-4511-b61d-75a947929d84', 'B', true,  1700),
('a0027771-969f-48df-adc0-d75790e33b22', '02e92a2a-58dd-47e5-a1e3-9a90bfd1830e', 'f07f560d-fe8c-4da3-a5a0-a9c90ef0d06e', 'f379cc84-5936-4511-b61d-75a947929d84', 'B', true,  2000),
('46339957-7a9c-456f-89d7-63e1b6e5f63e', '02e92a2a-58dd-47e5-a1e3-9a90bfd1830e', '1fb3203a-37e1-4192-8a25-5a83bd8adc99', 'f379cc84-5936-4511-b61d-75a947929d84', 'A', false, 2800),

-- 학생5 (우수: T T T)
('3c49af75-3181-4557-8abc-ee369aa546f7', '02e92a2a-58dd-47e5-a1e3-9a90bfd1830e', 'e0bad897-00d9-40ec-8bbb-e8296720d674', 'a7696bd1-9fd8-43af-b580-a164733a65dc', 'B', true,  900),
('94f50fca-3349-4907-81b8-566abe942940', '02e92a2a-58dd-47e5-a1e3-9a90bfd1830e', 'f07f560d-fe8c-4da3-a5a0-a9c90ef0d06e', 'a7696bd1-9fd8-43af-b580-a164733a65dc', 'B', true,  1000),
('5ae83997-1889-4919-aa6a-7f02f0609a6c', '02e92a2a-58dd-47e5-a1e3-9a90bfd1830e', '1fb3203a-37e1-4192-8a25-5a83bd8adc99', 'a7696bd1-9fd8-43af-b580-a164733a65dc', 'C', true,  800),

-- 학생6 (취약: F F T)
('8f17548f-77dc-4dcc-a9ea-c4a9e986c37d', '02e92a2a-58dd-47e5-a1e3-9a90bfd1830e', 'e0bad897-00d9-40ec-8bbb-e8296720d674', 'cef3fb12-74ee-4d2d-8d5d-146e87d83b48', 'C', false, 4500),
('f783ad64-e323-4c26-bfa1-03fa928a02a4', '02e92a2a-58dd-47e5-a1e3-9a90bfd1830e', 'f07f560d-fe8c-4da3-a5a0-a9c90ef0d06e', 'cef3fb12-74ee-4d2d-8d5d-146e87d83b48', 'D', false, 5000),
('7eb2f85e-4c22-4dbc-a777-00d6d1021695', '02e92a2a-58dd-47e5-a1e3-9a90bfd1830e', '1fb3203a-37e1-4192-8a25-5a83bd8adc99', 'cef3fb12-74ee-4d2d-8d5d-146e87d83b48', 'C', true,  3800),

-- 학생7 (취약: T F F)
('8331e924-b410-44c2-9610-4720eb2008c8', '02e92a2a-58dd-47e5-a1e3-9a90bfd1830e', 'e0bad897-00d9-40ec-8bbb-e8296720d674', 'e37ffc43-82de-4d9e-a143-2ad548cb6f2d', 'B', true,  2200),
('212deff8-f5e3-4f35-93e2-3e5158aeaab7', '02e92a2a-58dd-47e5-a1e3-9a90bfd1830e', 'f07f560d-fe8c-4da3-a5a0-a9c90ef0d06e', 'e37ffc43-82de-4d9e-a143-2ad548cb6f2d', 'A', false, 4200),
('941952af-b576-4dcf-b607-08d764b88f94', '02e92a2a-58dd-47e5-a1e3-9a90bfd1830e', '1fb3203a-37e1-4192-8a25-5a83bd8adc99', 'e37ffc43-82de-4d9e-a143-2ad548cb6f2d', 'B', false, 4800),

-- 학생8 (보통: F T T)
('62cf07f6-706c-4706-bd00-985ae44e9a7b', '02e92a2a-58dd-47e5-a1e3-9a90bfd1830e', 'e0bad897-00d9-40ec-8bbb-e8296720d674', 'b2ed5cb9-0e31-4929-9774-d1dc3be100a1', 'D', false, 3000),
('8e1b81b6-fac8-423f-9f94-6b18d8416ed2', '02e92a2a-58dd-47e5-a1e3-9a90bfd1830e', 'f07f560d-fe8c-4da3-a5a0-a9c90ef0d06e', 'b2ed5cb9-0e31-4929-9774-d1dc3be100a1', 'B', true,  1600),
('ae99034f-04ca-490c-8d1c-70925745f508', '02e92a2a-58dd-47e5-a1e3-9a90bfd1830e', '1fb3203a-37e1-4192-8a25-5a83bd8adc99', 'b2ed5cb9-0e31-4929-9774-d1dc3be100a1', 'C', true,  1400),

-- 학생9 (취약: F T F)
('2c1c283b-2c3b-4f9f-9683-b4c5abe78692', '02e92a2a-58dd-47e5-a1e3-9a90bfd1830e', 'e0bad897-00d9-40ec-8bbb-e8296720d674', '744d8720-213d-4a28-bac2-4099cc9cb046', 'A', false, 4100),
('558bdfb5-4702-44ba-8b3f-7f7abd682697', '02e92a2a-58dd-47e5-a1e3-9a90bfd1830e', 'f07f560d-fe8c-4da3-a5a0-a9c90ef0d06e', '744d8720-213d-4a28-bac2-4099cc9cb046', 'B', true,  2300),
('0535d5d5-7689-4996-9de3-2890073c6043', '02e92a2a-58dd-47e5-a1e3-9a90bfd1830e', '1fb3203a-37e1-4192-8a25-5a83bd8adc99', '744d8720-213d-4a28-bac2-4099cc9cb046', 'A', false, 4600),

-- 학생10 (취약: F F T)
('225081d7-60f0-407d-8672-efb8171683df', '02e92a2a-58dd-47e5-a1e3-9a90bfd1830e', 'e0bad897-00d9-40ec-8bbb-e8296720d674', '14ca14a5-a14f-44b3-a508-23b39b44d3c5', 'C', false, 4900),
('4add7c32-487a-4628-83db-12b0d929e74d', '02e92a2a-58dd-47e5-a1e3-9a90bfd1830e', 'f07f560d-fe8c-4da3-a5a0-a9c90ef0d06e', '14ca14a5-a14f-44b3-a508-23b39b44d3c5', 'D', false, 5200),
('fe7b93ce-5837-45da-923a-4db3046a3dba', '02e92a2a-58dd-47e5-a1e3-9a90bfd1830e', '1fb3203a-37e1-4192-8a25-5a83bd8adc99', '14ca14a5-a14f-44b3-a508-23b39b44d3c5', 'C', true,  3400),

-- ── O5P6 세션 (cd89dbcc) ──

-- 학생1 (우수: T T T)
('0739b4a4-262a-4a07-a7df-344d78563b0a', 'cd89dbcc-aacd-4f59-9274-d450c47740dc', '43b206a1-cc03-4bc5-a801-2b57f588063b', '7714e381-4cd3-4e9c-8368-3ab57ed436de', 'A', true,  1100),
('c3c13d3a-506f-4b48-b317-ac30529ef02c', 'cd89dbcc-aacd-4f59-9274-d450c47740dc', '37c61f30-e82d-4842-8234-23002c0a56e9', '7714e381-4cd3-4e9c-8368-3ab57ed436de', 'C', true,  1300),
('1d4332bb-7f90-4902-934c-f1e6a1bc787a', 'cd89dbcc-aacd-4f59-9274-d450c47740dc', 'e4b7f6fd-4adf-4563-8022-4da2b8307893', '7714e381-4cd3-4e9c-8368-3ab57ed436de', 'B', true,  900),

-- 학생2 (보통: T T F)
('bfe2c5a8-c89a-4343-930f-aa11502b5f9f', 'cd89dbcc-aacd-4f59-9274-d450c47740dc', '43b206a1-cc03-4bc5-a801-2b57f588063b', '5398f3a5-36f5-4643-b44c-04c2a3cd542c', 'A', true,  2000),
('459182a6-275f-4597-867f-812bb4e4e5de', 'cd89dbcc-aacd-4f59-9274-d450c47740dc', '37c61f30-e82d-4842-8234-23002c0a56e9', '5398f3a5-36f5-4643-b44c-04c2a3cd542c', 'C', true,  1800),
('ef81366c-db37-4b3d-a716-f3b4f727e8cf', 'cd89dbcc-aacd-4f59-9274-d450c47740dc', 'e4b7f6fd-4adf-4563-8022-4da2b8307893', '5398f3a5-36f5-4643-b44c-04c2a3cd542c', 'A', false, 3500),

-- 학생3 (보통: T F T)
('bb86a224-045a-465c-8fe5-743259334cbc', 'cd89dbcc-aacd-4f59-9274-d450c47740dc', '43b206a1-cc03-4bc5-a801-2b57f588063b', 'c77287ad-4858-40b5-ae47-07d481b5ba28', 'A', true,  1600),
('9d29f31c-eec8-4add-8a80-bc6f0202d1d4', 'cd89dbcc-aacd-4f59-9274-d450c47740dc', '37c61f30-e82d-4842-8234-23002c0a56e9', 'c77287ad-4858-40b5-ae47-07d481b5ba28', 'A', false, 4000),
('5e8638c0-f19a-4866-8a01-8b45a38136bc', 'cd89dbcc-aacd-4f59-9274-d450c47740dc', 'e4b7f6fd-4adf-4563-8022-4da2b8307893', 'c77287ad-4858-40b5-ae47-07d481b5ba28', 'B', true,  1200),

-- 학생4 (보통: F T T)
('a3f440e0-2aee-4322-b877-a7e6a313ea14', 'cd89dbcc-aacd-4f59-9274-d450c47740dc', '43b206a1-cc03-4bc5-a801-2b57f588063b', 'f379cc84-5936-4511-b61d-75a947929d84', 'B', false, 3200),
('be118af7-4967-4d15-ba24-d145bda14bcf', 'cd89dbcc-aacd-4f59-9274-d450c47740dc', '37c61f30-e82d-4842-8234-23002c0a56e9', 'f379cc84-5936-4511-b61d-75a947929d84', 'C', true,  1900),
('6c42223d-5233-4a3c-8560-729008dcc99b', 'cd89dbcc-aacd-4f59-9274-d450c47740dc', 'e4b7f6fd-4adf-4563-8022-4da2b8307893', 'f379cc84-5936-4511-b61d-75a947929d84', 'B', true,  1500),

-- 학생5 (우수: T T T)
('86917cf2-89ae-408a-89eb-b5ba9cfc05fe', 'cd89dbcc-aacd-4f59-9274-d450c47740dc', '43b206a1-cc03-4bc5-a801-2b57f588063b', 'a7696bd1-9fd8-43af-b580-a164733a65dc', 'A', true,  800),
('64792112-8c17-4a7c-83a9-142efe19078d', 'cd89dbcc-aacd-4f59-9274-d450c47740dc', '37c61f30-e82d-4842-8234-23002c0a56e9', 'a7696bd1-9fd8-43af-b580-a164733a65dc', 'C', true,  700),
('5c0af48e-10e7-4d99-b945-1af6033540df', 'cd89dbcc-aacd-4f59-9274-d450c47740dc', 'e4b7f6fd-4adf-4563-8022-4da2b8307893', 'a7696bd1-9fd8-43af-b580-a164733a65dc', 'B', true,  1000),

-- 학생6 (취약: T F F)
('d6b58073-4225-4dd0-a933-a45d4dcaf145', 'cd89dbcc-aacd-4f59-9274-d450c47740dc', '43b206a1-cc03-4bc5-a801-2b57f588063b', 'cef3fb12-74ee-4d2d-8d5d-146e87d83b48', 'A', true,  2500),
('ad08681f-2fd6-43e6-b2c9-386508ca9349', 'cd89dbcc-aacd-4f59-9274-d450c47740dc', '37c61f30-e82d-4842-8234-23002c0a56e9', 'cef3fb12-74ee-4d2d-8d5d-146e87d83b48', 'B', false, 4800),
('f13af3da-df6b-4cec-84d4-b08cc36f4de9', 'cd89dbcc-aacd-4f59-9274-d450c47740dc', 'e4b7f6fd-4adf-4563-8022-4da2b8307893', 'cef3fb12-74ee-4d2d-8d5d-146e87d83b48', 'D', false, 5100),

-- 학생7 (취약: F T F)
('607fa125-5002-45aa-b043-82218ad802ef', 'cd89dbcc-aacd-4f59-9274-d450c47740dc', '43b206a1-cc03-4bc5-a801-2b57f588063b', 'e37ffc43-82de-4d9e-a143-2ad548cb6f2d', 'C', false, 4300),
('f3057145-1f50-4d5e-b660-39911be293e8', 'cd89dbcc-aacd-4f59-9274-d450c47740dc', '37c61f30-e82d-4842-8234-23002c0a56e9', 'e37ffc43-82de-4d9e-a143-2ad548cb6f2d', 'C', true,  2100),
('afaf2f11-68be-4cbd-aaea-d118ea2ed01c', 'cd89dbcc-aacd-4f59-9274-d450c47740dc', 'e4b7f6fd-4adf-4563-8022-4da2b8307893', 'e37ffc43-82de-4d9e-a143-2ad548cb6f2d', 'A', false, 4700),

-- 학생8 (보통: T T F)
('dd6037d5-b051-41f8-8691-3aeb8ab1cd14', 'cd89dbcc-aacd-4f59-9274-d450c47740dc', '43b206a1-cc03-4bc5-a801-2b57f588063b', 'b2ed5cb9-0e31-4929-9774-d1dc3be100a1', 'A', true,  1700),
('c5e53dbe-0ac0-44cf-b451-2f87e5bd1b59', 'cd89dbcc-aacd-4f59-9274-d450c47740dc', '37c61f30-e82d-4842-8234-23002c0a56e9', 'b2ed5cb9-0e31-4929-9774-d1dc3be100a1', 'C', true,  1400),
('fdf76a39-c005-4c4a-882e-f1e4f198abfe', 'cd89dbcc-aacd-4f59-9274-d450c47740dc', 'e4b7f6fd-4adf-4563-8022-4da2b8307893', 'b2ed5cb9-0e31-4929-9774-d1dc3be100a1', 'D', false, 3600),

-- 학생9 (취약: F F T)
('48375f54-491e-4107-a492-ae15c106d597', 'cd89dbcc-aacd-4f59-9274-d450c47740dc', '43b206a1-cc03-4bc5-a801-2b57f588063b', '744d8720-213d-4a28-bac2-4099cc9cb046', 'D', false, 5000),
('d042d054-44a2-42ac-a245-b3201c24a341', 'cd89dbcc-aacd-4f59-9274-d450c47740dc', '37c61f30-e82d-4842-8234-23002c0a56e9', '744d8720-213d-4a28-bac2-4099cc9cb046', 'B', false, 4400),
('02abb881-7ab1-4024-a10b-2992e90ad8b0', 'cd89dbcc-aacd-4f59-9274-d450c47740dc', 'e4b7f6fd-4adf-4563-8022-4da2b8307893', '744d8720-213d-4a28-bac2-4099cc9cb046', 'B', true,  2600),

-- 학생10 (취약: F F T)
('4b4fbc6e-0250-404f-9061-6c73c4e462c0', 'cd89dbcc-aacd-4f59-9274-d450c47740dc', '43b206a1-cc03-4bc5-a801-2b57f588063b', '14ca14a5-a14f-44b3-a508-23b39b44d3c5', 'C', false, 4800),
('32662b11-39f5-42d8-a13e-0b1f5f13e599', 'cd89dbcc-aacd-4f59-9274-d450c47740dc', '37c61f30-e82d-4842-8234-23002c0a56e9', '14ca14a5-a14f-44b3-a508-23b39b44d3c5', 'A', false, 5300),
('ba192098-c16a-4d6c-9ea8-93b54838a46c', 'cd89dbcc-aacd-4f59-9274-d450c47740dc', 'e4b7f6fd-4adf-4563-8022-4da2b8307893', '14ca14a5-a14f-44b3-a508-23b39b44d3c5', 'B', true,  2900);
