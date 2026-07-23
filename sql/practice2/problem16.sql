-- 문제 16
-- 자신의 학과 평균 GPA보다 높은 학생
-- (Correlated subquery)
SELECT
    s.student_id as "학번",
    s.name as "이름",
    s.major as "전공",
    s.gpa as "GPA"
FROM student s
WHERE s.gpa > (
    SELECT AVG(tmp.gpa)
    FROM student tmp
    WHERE tmp.major = s.major
)
ORDER BY s.student_id
LIMIT 5;