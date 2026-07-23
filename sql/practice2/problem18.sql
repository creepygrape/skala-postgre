-- 문제 18
-- 한 번도 수강하지 않은 학생
-- 수강 기록이 없는 학생들의 평균 GPA보다 높은 GPA를 가진 학생 목록
with tmp as (
    SELECT
    s.student_id,
    s.name,
    s.major,
    s.gpa
    FROM student s
    WHERE NOT EXISTS (
        SELECT 1
        FROM enroll e
        WHERE e.student_id = s.student_id
    )
)
SELECT
    s.student_id as "학번",
    s.name as "이름",
    s.major as "전공",
    s.gpa as "GPA"
FROM student s
WHERE s.gpa > (
    SELECT AVG(gpa)
    FROM tmp
)
ORDER BY s.student_id
LIMIT 5;