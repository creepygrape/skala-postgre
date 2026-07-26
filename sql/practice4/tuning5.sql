SELECT 
    c.customer_id AS "고객 번호",
    TO_CHAR(MAX(o.order_ts), 'YYYY-MM-DD HH24:MI:SS') AS "마지막 구매일",
    COUNT(DISTINCT CASE WHEN o.order_ts >= CURRENT_DATE - INTERVAL '30 days' THEN o.order_id END) AS "최근 30일 총 주문건수",
    COALESCE(SUM(CASE WHEN o.order_ts >= CURRENT_DATE - INTERVAL '30 days' THEN oi.line_total ELSE 0 END), 0) AS "최근 30일 총 구매액"
FROM customers c
LEFT JOIN orders o 
    ON c.customer_id = o.customer_id 
   AND o.order_status IN ('paid', 'shipped', 'delivered')
LEFT JOIN order_items oi 
    ON o.order_id = oi.order_id
GROUP BY c.customer_id
ORDER BY c.customer_id ASC
LIMIT 10;