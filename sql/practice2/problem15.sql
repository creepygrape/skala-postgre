-- 문제 15
-- 평균 GPA 보다 높은 학생 (WHERE 서브쿼리)
-- GPA가 NULL인 경우 제외 ... NULL 데이터 없음
SELECT
    s.student_id as "학번",
    s.name as "이름",
    s.major as "전공",
    s.gpa as "GPA"
FROM student s
WHERE s.gpa > (
    SELECT AVG(gpa)
    FROM student
)
ORDER BY student_id
LIMIT 5;