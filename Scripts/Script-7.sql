-- ============================================================
-- 1. COALESCE 활용 (NULL 값을 대체값으로 변환)
-- ============================================================

-- [1-1] 전화번호(phone)가 NULL이면 '미등록'으로 처리하여 조회
SELECT 
    name, 
    COALESCE(phone, '미등록') AS contact_phone
FROM academic.Student;

-- [1-2] 수강 성적 비고(grade_remark)가 NULL이면 '특이사항 없음'으로 대체하여 조회
SELECT 
    enrollment_id, 
    student_id, 
    grade, 
    COALESCE(grade_remark, '특이사항 없음') AS remark
FROM academic.Enrollment;


-- ============================================================
-- 2. CASE WHEN 활용 (조건문 / 값 변환)
-- ============================================================

-- [2-1] 점수(final_score) 구간에 따라 합격 여부(PASS/FAIL) 처리
SELECT 
    enrollment_id, 
    student_id, 
    final_score,
    CASE 
        WHEN final_score >= 80.0 THEN '합격 (Pass)'
        WHEN final_score IS NULL THEN '미응시'
        ELSE '불합격 (Fail)'
    END AS pass_status
FROM academic.Enrollment;

-- [2-2] 학년(grade)에 따라 저학년/고학년 구분 라벨 부여
SELECT 
    student_id, 
    name, 
    grade,
    CASE grade
        WHEN 1 THEN '1학년 (신입생)'
        WHEN 2 THEN '2학년 (저학년)'
        WHEN 3 THEN '3학년 (고학년)'
        WHEN 4 THEN '4학년 (예비졸업생)'
        ELSE '기타'
    END AS grade_label
FROM academic.Student;


-- ============================================================
-- 3. 날짜 함수 활용 (NOW, EXTRACT, AGE, TO_CHAR 등)
-- ============================================================

-- [3-1] 현재 시간 및 날짜 조회 함수
SELECT 
    CURRENT_DATE AS 오늘날짜, 
    CURRENT_TIME AS 현재시각, 
    NOW() AS 현재날짜및시각;

-- [3-2] 생년월일(birth)을 바탕으로 만 나이 계산 (AGE 함수)
SELECT 
    name, 
    birth, 
    AGE(CURRENT_DATE, birth) AS 정확한_나이,
    EXTRACT(YEAR FROM AGE(CURRENT_DATE, birth)) AS 만_나이
FROM academic.Student;

-- [3-3] 생년월일에서 연도/월/일만 추출 (EXTRACT 함수)
SELECT 
    name, 
    birth, 
    EXTRACT(YEAR FROM birth) AS 출생연도,
    EXTRACT(MONTH FROM birth) AS 출생월,
    EXTRACT(DAY FROM birth) AS 출생일
FROM academic.Student;

-- [3-4] 날짜 형식을 원하는 문자열 포맷으로 변환 (TO_CHAR 함수)
SELECT 
    name, 
    created_at, 
    TO_CHAR(created_at, 'YYYY년 MM월 DD일 HH24시 MI분') AS 가입일시_포맷
FROM academic.Student;


-- ============================================================
-- 4. COALESCE + CASE WHEN + 날짜 함수 종합 응용
-- ============================================================

-- [4-1] 생년월일 기반 생일월 분기 분류 및 전화번호 NULL 처리
SELECT 
    name,
    COALESCE(phone, '연락처 없음') AS phone_info,
    TO_CHAR(birth, 'MM-DD') AS birth_day,
    CASE 
        WHEN EXTRACT(MONTH FROM birth) IN (3, 4, 5) THEN '봄 생일'
        WHEN EXTRACT(MONTH FROM birth) IN (6, 7, 8) THEN '여름 생일'
        WHEN EXTRACT(MONTH FROM birth) IN (9, 10, 11) THEN '가을 생일'
        ELSE '겨울 생일'
    END AS birth_season
FROM academic.Student
ORDER BY birth_season, name;

-- [4-2] 학생 가입 연차 계산 및 최근 가입 여부 판별
SELECT 
    student_id,
    name,
    TO_CHAR(created_at, 'YYYY-MM-DD') AS reg_date,
    EXTRACT(YEAR FROM AGE(NOW(), created_at)) AS registered_years,
    CASE 
        WHEN created_at >= NOW() - INTERVAL '1 year' THEN '신규 등록'
        ELSE '기존 등록'
    END AS member_type
FROM academic.Student
ORDER BY created_at DESC;