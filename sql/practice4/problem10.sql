-- Q10) 상위 1% 고객의 최근 60일 매출
-- 총 주문 금액 기준 상위 1%
WITH customer_total_amount AS (
  SELECT
    o.customer_id,
    SUM(oi.line_total) AS total_amount,
    percent_rank() OVER (ORDER BY SUM(oi.line_total) DESC) AS ranking
  FROM orders o
  JOIN order_items oi
    ON oi.order_id = o.order_id
  GROUP BY o.customer_id
),
top_1pct_customers AS (
  SELECT
    customer_id
  FROM customer_total_amount
  WHERE ranking <= 0.01
)
SELECT
  o.customer_id AS "고객 번호",
  COUNT(o.order_id) AS "최근 60일 주문건수",
  SUM(oi.line_total) AS "최근 60일 총 매출"
FROM orders o
JOIN top_1pct_customers
  ON top_1pct_customers.customer_id = o.customer_id
JOIN order_items oi
  ON oi.order_id = o.order_id
WHERE o.order_ts <= CURRENT_DATE
  AND o.order_ts >= CURRENT_DATE - INTERVAL '60 days'
GROUP BY o.customer_id
ORDER BY "최근 60일 총 매출" DESC