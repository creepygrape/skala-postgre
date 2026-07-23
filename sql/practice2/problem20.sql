-- 문제 20
-- CS 학과 학생 또는 DB 과목을 수강한 학생 목록
SELECT
    s.student_id,
    s.name,
    s.major,
    s.gpa
FROM student s
WHERE s.major ='CS' -- CS 학과
OR EXISTS ( -- DB 과목 수강
    SELECT 1
    FROM enroll e
    WHERE e.course = 'DB'
)
ORDER BY s.student_id
LIMIT 5;