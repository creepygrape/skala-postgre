-- 문제 1
-- 학생과 수강을 INNER JOIN하여
-- 수강 존재 학생의 과목/성적을 조회
SELECT 
    s.name as 학생,
    e.course as 과목,
    e.grade as 성적
FROM student as s
INNER JOIN enroll as e
    ON e.student_id = s.student_id
order by s.student_id asc, e.course asc
limit 5;
