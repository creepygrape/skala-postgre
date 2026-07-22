-- '컴퓨터공학과'에 소속된 학생들을 이름 순으로 오름차순 정렬
-- (student_department 교차 테이블 또는 department 테이블과 JOIN 필요)
SELECT 
    s.student_id, 
    s.name AS student_name, 
    d.department_name, 
    s.grade,
    s.status
FROM academic.student s
JOIN academic.student_department sd ON s.id = sd.student_id
JOIN academic.department d ON sd.department_id = d.id
WHERE d.department_name = '컴퓨터공학과'
ORDER BY s.name ASC;