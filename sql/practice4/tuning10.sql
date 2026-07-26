CREATE MATERIALIZED VIEW mv_customer_rank AS
SELECT
  o.customer_id,
  SUM(oi.line_total) AS total_amount,
  percent_rank() OVER (ORDER BY SUM(oi.line_total) DESC) AS ranking
FROM orders o
JOIN order_items oi ON oi.order_id = o.order_id
GROUP BY o.customer_id;

-- MV 조인 및 필터링 속도를 극대화하기 위한 인덱스 생성
CREATE UNIQUE INDEX idx_mv_cust_rank_id ON mv_customer_rank (customer_id);
CREATE INDEX idx_mv_cust_rank_ranking ON mv_customer_rank (ranking);

EXPLAIN (ANALYZE, BUFFERS)
SELECT
  o.customer_id AS "고객 번호",
  COUNT(o.order_id) AS "최근 60일 주문건수",
  SUM(oi.line_total) AS "최근 60일 총 매출"
FROM mv_customer_rank mv
JOIN orders o 
  ON o.customer_id = mv.customer_id
  AND o.order_ts >= CURRENT_DATE - INTERVAL '60 days'
  AND o.order_ts <= CURRENT_DATE
JOIN order_items oi 
  ON oi.order_id = o.order_id
WHERE mv.ranking <= 0.01  -- 미리 계산된 상위 1% 조건만 즉시 조회
GROUP BY o.customer_id
ORDER BY "최근 60일 총 매출" DESC;