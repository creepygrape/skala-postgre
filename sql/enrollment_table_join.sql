-- 학생(Student), 개설강좌(Section), 과목(Course) 테이블을 서로 JOIN하여
-- 누가 어떤 과목을 수강하고 중간/기말 성적을 받았는지 전체 내역을 조회
SELECT 
    s.student_id,
    s.name AS student_name,
    c.title AS course_title,
    sec.year,
    sec.semester,
    e.mid_score,
    e.final_score,
    e.grade AS final_letter_grade
FROM enrollment e
JOIN student s ON e.student_id = s.id
JOIN section sec ON e.section_id = sec.id
JOIN course c ON sec.course_id = c.id
ORDER BY s.student_id ASC, sec.year DESC;