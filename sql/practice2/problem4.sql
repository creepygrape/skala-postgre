-- 문제 4
-- 학생/수강 모두 포함
SELECT
    *
FROM student as s
FULL OUTER JOIN enroll as e
    ON e.student_id = s.student_id
ORDER BY e.course asc, s.student_id asc
limit 5;