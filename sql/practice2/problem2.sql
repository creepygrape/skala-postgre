-- 문제 2
-- 모든 학생 기준으로 수강을 붙이고,
-- 과목(없으면 NULL)까지 보이기
SELECT
    s.name as 학생,
    e.course as 과목
FROM student as s
LEFT JOIN enroll as e
    ON s.student_id = e.student_id
ORDER BY s.student_id asc, e.course asc
limit 5;