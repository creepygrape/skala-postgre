-- ============================================================
-- 1. SELECT 기초 (원하는 컬럼/열 선택 조회)
-- ============================================================

-- [1-1] Student 테이블의 모든 컬럼(*) 데이터 조회
SELECT * 
FROM academic.Student;

-- [1-2] Student 테이블에서 학번(student_id), 이름(name), 학년(grade) 컬럼만 지정하여 조회
SELECT student_id, name, grade 
FROM academic.Student;


-- ============================================================
-- 2. WHERE 기초 (조건을 만족하는 행/레코드 필터링)
-- ============================================================

-- [2-1] 비교 연산자: 3학년 이상(>= 3)인 학생만 조회
SELECT name, grade, status 
FROM academic.Student 
WHERE grade >= 3;

-- [2-2] 논리 연산자(AND): 3학년이면서 동시에 현재 '재학' 중인 학생 조회
SELECT name, grade, status 
FROM academic.Student 
WHERE grade = 3 AND status = '재학';

-- [2-3] 범위 연산자(BETWEEN): 중간고사 점수가 80점 이상 90점 이하인 수강 기록 조회
SELECT enrollment_id, student_id, mid_score 
FROM academic.Enrollment 
WHERE mid_score BETWEEN 80 AND 90;

-- [2-4] 목록 연산자(IN): 직급이 '정교수' 또는 '부교수'인 교수님 목록 조회
SELECT name, position 
FROM academic.Professor 
WHERE position IN ('정교수', '부교수');

-- [2-5] 패턴 매칭(LIKE): 성씨가 '김'으로 시작하는 학생 조회 (%는 임의의 문자열)
SELECT student_id, name, email 
FROM academic.Student 
WHERE name LIKE '김%';


-- ============================================================
-- 3. ORDER BY 기초 (조회 결과 데이터 정렬)
-- ============================================================

-- [3-1] 오름차순 정렬(ASC): 학년을 낮은 순서(1학년 -> 4학년)로 정렬하여 조회
SELECT name, grade 
FROM academic.Student 
ORDER BY grade ASC;

-- [3-2] 내림차순 정렬(DESC): 중간고사 점수를 높은 순서(100점 -> 0점)로 정렬하여 조회
SELECT enrollment_id, student_id, mid_score 
FROM academic.Enrollment 
ORDER BY mid_score DESC;

-- [3-3] 다중 컬럼 정렬: 1차로 학년 내림차순(4->1학년), 학년이 같으면 2차로 이름 오름차순(가나다순) 정렬
SELECT grade, name, student_id 
FROM academic.Student 
ORDER BY grade DESC, name ASC;


-- ============================================================
-- 4. SELECT + WHERE + ORDER BY 종합 활용
-- ============================================================

-- [4-1] 2학년 이상인 학생들을 조회하여 학년 내림차순, 이름 오름차순으로 정렬
SELECT student_id, name, grade, status
FROM academic.Student
WHERE grade >= 2
ORDER BY grade DESC, name ASC;

-- [4-2] 수강신청 상태가 'COMPLETED'이고 최종 점수가 80점 이상인 내역을 점수 높은 순으로 조회
SELECT enrollment_id, student_id, section_id, final_score, grade
FROM academic.Enrollment
WHERE status = 'COMPLETED' AND final_score >= 80.00
ORDER BY final_score DESC;