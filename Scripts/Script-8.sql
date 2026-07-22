-- ============================================================
-- 1. 기본 JOIN (수강신청 + 학생 + 개설강좌)
-- ============================================================

-- [1-1] 누가 무슨 강좌를 신청했는지 기본 정보만 조회 (INNER JOIN)
SELECT 
    e.enrollment_id,
    s.student_id,
    s.name AS student_name,
    sec.section_id,
    sec.year,
    sec.semester
FROM academic.Enrollment e
JOIN academic.Student s ON e.student_id = s.id
JOIN academic.Section sec ON e.section_id = sec.id;


-- ============================================================
-- 2. 핵심 교차 JOIN (수강신청 + 학생 + 과목명 + 교수명)
-- ============================================================

-- [2-1] 수강신청 내역에 과목 이름과 담당 교수 이름까지 연결하여 조회
SELECT 
    e.enrollment_id,
    s.student_id,
    s.name AS student_name,
    c.course_id,
    c.title AS course_title,
    p.name AS professor_name,
    e.status AS enrollment_status
FROM academic.Enrollment e
JOIN academic.Student s ON e.student_id = s.id
JOIN academic.Section sec ON e.section_id = sec.id
JOIN academic.Course c ON sec.course_id = c.id
JOIN academic.Professor p ON sec.professor_id = p.id
ORDER BY s.student_id, c.course_id;


-- ============================================================
-- 3. 조건 필터링 + JOIN (특정 학생 / 특정 강좌 수강생 명단)
-- ============================================================

-- [3-1] 특정 학생('김철수')이 신청한 과목과 성적, 학점 조회
SELECT 
    s.name AS student_name,
    c.course_id,
    c.title AS course_title,
    c.credit,
    e.mid_score,
    e.final_score,
    COALESCE(e.grade, '미입력') AS grade
FROM academic.Enrollment e
JOIN academic.Student s ON e.student_id = s.id
JOIN academic.Section sec ON e.section_id = sec.id
JOIN academic.Course c ON sec.course_id = c.id
WHERE s.name = '김철수';

-- [3-2] 특정 과목('컴퓨터학개론', CS101)을 수강하는 학생 명단 조회
SELECT 
    c.title AS course_title,
    sec.class AS class_no,
    s.student_id,
    s.name AS student_name,
    s.grade AS student_year,
    s.phone
FROM academic.Enrollment e
JOIN academic.Student s ON e.student_id = s.id
JOIN academic.Section sec ON e.section_id = sec.id
JOIN academic.Course c ON sec.course_id = c.id
WHERE c.course_id = 'CS101'
ORDER BY sec.class, s.student_id;


-- ============================================================
-- 4. 풀 패키지 다중 JOIN (수강신청 상세 종합 명세서)
-- ============================================================

-- [4-1] 수강신청, 학생, 과목, 개설학과, 담당교수, 시간표 정보까지 일괄 조회
SELECT 
    e.enrollment_id,
    s.student_id,
    s.name AS student_name,
    d.department_name AS offering_dept, -- 개설 학과
    c.title AS course_title,
    sec.classroom,
    p.name AS professor_name,
    sch.day_of_week,
    sch.start_time,
    sch.end_time,
    e.is_retake AS 재수강여부
FROM academic.Enrollment e
JOIN academic.Student s ON e.student_id = s.id
JOIN academic.Section sec ON e.section_id = sec.id
JOIN academic.Course c ON sec.course_id = c.id
JOIN academic.Department d ON sec.department_id = d.id
JOIN academic.Professor p ON sec.professor_id = p.id
LEFT JOIN academic.Section_Schedule sch ON sec.id = sch.section_id
ORDER BY e.enrollment_id;