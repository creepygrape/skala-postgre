-- Q3) 최근 90일 카테고리 Top 10
-- 1. 최근 90일 주문건에서
-- 2. 카테고리별 물품 판매 개수 집계
SELECT 
    c.category_id,
    c.category_name,
    SUM(oi.qty) AS "총 주문 수량"
FROM orders o
INNER JOIN order_items oi ON o.order_id = oi.order_id
INNER JOIN products p ON oi.product_id = p.product_id
INNER JOIN categories c ON p.category_id = c.category_id
WHERE o.order_ts <= CURRENT_DATE 
    AND o.order_ts >= CURRENT_DATE  - INTERVAL '90 days'
    AND o.order_status IN ('paid', 'shipped', 'delivered')        -- 유효 주문 상태 필터링
GROUP BY 
    c.category_id, 
    c.category_name
ORDER BY 
    "총 주문 수량" DESC
LIMIT 10;