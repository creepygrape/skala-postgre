-- Materialized View 활용
-- mv_daily_gmv(일일 총 거래액)로 리포트 질의 가속, 갱신 전략 검토
-- 오후 3시 기준 갱신

DROP MATERIALIZED VIEW IF EXISTS mv_daily_gmv CASCADE;

CREATE MATERIALIZED VIEW mv_daily_gmv AS
SELECT
  DATE(o.order_ts) AS DAY,
  SUM(oi.line_total) AS GMV,
  COUNT(o.order_id) AS TOTAL_ORDERS,
  COUNT(DISTINCT o.customer_id) AS ACTIVE_BUYERS
FROM orders o
JOIN order_items oi
  ON oi.order_id = o.order_id
WHERE o.order_status in ('paid', 'shipped', 'delivered')
GROUP BY DATE(o.order_ts);

CREATE UNIQUE INDEX idx_mv_daily_gmv_day ON mv_daily_gmv (day);

-- SELECT cron.schedule(
--   'refresh_mv_daily_gmv_job',
--   '0 15 * * *',
--   'REFRESH MATERIALIZED VIEW CONCURRENTLY mv_daily_gmv;'
-- );

REFRESH MATERIALIZED VIEW CONCURRENTLY mv_daily_gmv;

-- 성능 분석 대상: Materialized View 조회 쿼리
-- EXPLAIN (ANALYZE, BUFFERS)
SELECT * 
FROM mv_daily_gmv 
WHERE day >= CURRENT_DATE - INTERVAL '1 month';