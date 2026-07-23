-- 문제 11
-- DB 과목을 듣지 않은 모든 학생을 나열
-- LIMIT을 쓰면 반환 순서가 달라짐
SELECT
    s.student_id as "학번",
    s.name as "학생 이름"
FROM student s
WHERE NOT EXISTS (
    SELECT 1
    FROM enroll e
    WHERE e.student_id = s.student_id
        AND e.course = 'DB'
)
LIMIT 5;