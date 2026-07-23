-- 문제 13
-- 학생 × 과목 전체 조합을 만들어 “학생별 과목 추천 후보”를 만들되,
-- 샘플 100건만 본다
SELECT
    s.name as "학생 이름",
    e.course as "추천 과목"
FROM student s
CROSS JOIN enroll e
LIMIT 100;
