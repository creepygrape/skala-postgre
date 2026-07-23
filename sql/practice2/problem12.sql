-- 문제 12
-- (가정) 과목별로 매니저가 운영 책임을 갖는다고 가정하고,
-- emp의 매니저(이름 ‘Mgr_’로 시작)와 과목을 임의로 매핑한 테이블
-- course_owner(course, manager_id)를 만든 뒤,
-- 과목별 수강 인원 + 책임 매니저 이름 리포트를 작성하세요

-- course_owner 테이블 생성
-- 랜덤 매핑하려다가 확인용 데이터만 넣었음
CREATE TABLE IF NOT EXISTS course_owner (
    course VARCHAR(50) PRIMARY KEY,
    manager_id INT NOT NULL REFERENCES emp(emp_id)
);
INSERT INTO course_owner (course, manager_id)
    VALUES
        ('DB', 2),
        ('AI', 3),
        ('ML', 4),
        ('Course_1', 5),
        ('Course_2', 6),
        ('Course_3', 7),
        ('Course_4', 8),
        ('Course_5', 9),
        ('Course_6', 10),
        ('Course_7', 11)
    ON CONFLICT (course) DO NOTHING; -- 이미 같은 과목이 있으면 skip

-- 과목별 수강 인원 + 책임 매니저 이름
SELECT
    e.course as "과목 이름",
    COUNT(DISTINCT e.student_id) as "수강 인원",
    m.name as "책임 매니저 이름"
FROM enroll e
LEFT JOIN course_owner co
    ON co.course = e.course
JOIN emp m
    ON m.emp_id = co.manager_id
GROUP BY e.course, m.name
ORDER BY e.course;
