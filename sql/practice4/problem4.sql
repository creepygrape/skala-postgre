-- Q4) 제품별 누적매출 RANK() Top 20
SELECT 
    RANK() OVER (ORDER BY SUM(oi.line_total) DESC) AS "순위",
    p.product_id AS "제품 ID",
    p.product_name AS "제품명",
    SUM(oi.line_total) AS "총 누적 매출" -- line_total = qty * unit_price
FROM orders o
INNER JOIN order_items oi ON o.order_id = oi.order_id
INNER JOIN products p ON oi.product_id = p.product_id
WHERE o.order_status IN ('paid', 'shipped', 'delivered')
GROUP BY 
    p.product_id, 
    p.product_name
ORDER BY 
    "순위" ASC
LIMIT 20;