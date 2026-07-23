-- 문제 14
-- 스칼라 서브쿼리 (SELECT 절) 사용
-- 학생 + 소속 학과명 붙이기
SELECT
    s.student_id as "학번",
    s.name || (SELECT s.major) as "학생이름 + 소속 학과"
FROM student s
ORDER BY s.student_id
LIMIT 5;