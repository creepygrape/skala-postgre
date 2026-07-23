-- 문제 8
-- 총액 상위 10명과 금액
SELECT
    c.customer_id as 고객번호,
    c.customer_name as 고객이름,
    sum(o.amount) as 총액
FROM customers c
INNER JOIN orders o
    ON c.customer_id = o.customer_id
GROUP BY c.customer_id
ORDER BY 총액 desc, c.customer_id asc
limit 10;