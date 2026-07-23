-- 문제 6
-- 한 과목 이상 수강한 학생 목록(중복 제거)
SELECT 
    s.*
FROM student s
WHERE s.student_id IN (
    SELECT
        DISTINCT e.student_id
    FROM enroll e
    where e.student_id = s.student_id
)
ORDER BY s.student_id ASC
limit 5;