-- 문제 19
-- HR 학과 학생 일부와의 비교 데모
-- HR 학과 최저 GPA 이상의 GPA를 가진 학생
SELECT
    s.student_id as "학번",
    s.name as "이름",
    s.major as "전공",
    s.gpa as "GPA"
FROM student s
WHERE s.gpa > ANY (
    SELECT gpa
    FROM student
    WHERE major = 'HR'
)
ORDER BY s.student_id
LIMIT 5;

-- HR 학과 최고 GPA 이상의 GPA를 가진 학생
SELECT
    s.student_id as "학번",
    s.name as "이름",
    s.major as "전공",
    s.gpa as "GPA"
FROM student s
WHERE s.gpa >= ALL (
    SELECT s2.gpa
    FROM student s2
    WHERE s2.major = 'HR'
)
ORDER BY s.student_id
LIMIT 5;