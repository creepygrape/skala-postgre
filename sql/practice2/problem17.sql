-- 문제 17
-- 수강(enroll) 기록이 있는 학생만
-- 수강 기록이 있는 학생들의 평균 GPA보다 높은 GPA를 가진 학생 목록
with tmp as (
    SELECT
        s.student_id,
        s.name,
        s.major,
        s.gpa
    FROM student s
    WHERE s.student_id IN (
        SELECT DISTINCT e.student_id
        FROM enroll e
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