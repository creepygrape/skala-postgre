
-- Q1) 지난 한 달간 실제 팔린 총 금액 보기(paid + shipped + delivered)
SELECT
    SUM(p.amount) as total_amount
FROM orders o
INNER JOIN payments p
    ON o.order_id = p.order_id
    AND o.order_ts <= CURRENT_DATE 
    AND o.order_ts >= CURRENT_DATE  - INTERVAL '1 month'
WHERE o.order_status in ('paid', 'shipped', 'delivered')
