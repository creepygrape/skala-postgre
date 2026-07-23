-- 문제 3
-- 수강이 기준. 학생이 없으면 학생 정보가 NULL
SELECT
    e.course as 과목,
    s.*
FROM student as s
RIGHT JOIN enroll as e
    ON s.student_id = e.student_id
ORDER BY e.course asc, s.student_id asc
limit 5;