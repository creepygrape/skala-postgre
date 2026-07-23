-- 문제 5
-- 한 번도 수강하지 않은 학생 목록
SELECT
    s.*
FROM student as s
WHERE NOT EXISTS (
    SELECT e.student_id
    FROM enroll as e
    where s.student_id = e.student_id
)
ORDER BY s.student_id ASC
LIMIT 5;