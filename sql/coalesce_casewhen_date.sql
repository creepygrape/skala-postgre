-- coalesce 결과 확인을 위해 1학년의 phone=null
UPDATE student
SET phone = NULL
WHERE grade = 1;

-- 학생들의 출생년도(birth)를 기반으로 현재 나이와 연령대 구분을 계산하고, 상태(status) 등의 정보를 가공
SELECT 
    student_id,
    name,
    birth,
    -- 날짜 함수 활용 (출생일 기준 현재 만 나이 계산)
    EXTRACT(YEAR FROM AGE(CURRENT_DATE, birth)) AS age,
    -- 조건문(CASE WHEN) 활용 (나이에 따른 구분)
    CASE 
        WHEN EXTRACT(YEAR FROM AGE(CURRENT_DATE, birth)) <= 22 THEN '저연령/재학생'
        ELSE '고연령/일반'
    END AS age_group,
    -- COALESCE 활용 (NULL 가능성이 있는 PHONE 컬럼 대체 예시)
    COALESCE(phone, '연락처 없음') AS phone_number,
    status
FROM academic.student;