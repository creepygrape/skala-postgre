-- 문제 10
-- “모든 학생 기준”으로 과목 분포를 보고 싶다
-- → LEFT JOIN + 집계
SELECT
    COALESCE(e.course, '미수강') as "과목",
    COUNT(DISTINCT s.student_id) as "수강 인원"
FROM student s
LEFT JOIN enroll e
    ON e.student_id = s.student_id
GROUP BY e.course
ORDER BY e.course desc, e.course asc
limit 5;