-- 문제 7
-- 고객별 주문건수/총액
SELECT
    c.customer_name as 이름,
    count(order_id) as 주문건수,
    sum(o.amount) as 총액
FROM customers c
INNER JOIN orders o
    ON c.customer_id = o.customer_id
GROUP BY c.customer_id
ORDER BY c.customer_id asc
limit 5;