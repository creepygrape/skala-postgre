-- 문제 9
-- 모든 직원과 그 매니저 이름
-- 별칭에 공백 존재 시 큰 따옴표로 감싸야 함
SELECT
    e.emp_id as "직원 번호",
    e.name as "직원 이름",
    m.name as "담당 매니저 이름"
FROM emp e
LEFT JOIN emp m
    ON e.manager_id = m.emp_id
ORDER BY e.emp_id asc;
