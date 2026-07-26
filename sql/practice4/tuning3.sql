-- order_items: FK 조인 속도 향상
CREATE INDEX IF NOT EXISTS idx_order_items_order_id ON order_items (order_id);

-- 최근 90일 카테고리별 판매량 집계 Materialized View 생성
CREATE MATERIALIZED VIEW IF NOT EXISTS mv_top10_categories_90d AS
SELECT 
    c.category_id,
    c.category_name,
    SUM(oi.qty) AS total_qty
FROM orders o
INNER JOIN order_items oi ON o.order_id = oi.order_id
INNER JOIN products p ON oi.product_id = p.product_id
INNER JOIN categories c ON p.category_id = c.category_id
WHERE o.order_ts >= CURRENT_DATE - INTERVAL '90 days'
  AND o.order_ts <= CURRENT_DATE
  AND o.order_status IN ('paid', 'shipped', 'delivered')
GROUP BY 
    c.category_id, 
    c.category_name;

-- 무중단 갱신(CONCURRENTLY)을 위한 Unique Index
CREATE UNIQUE INDEX idx_mv_top10_cat_id 
ON mv_top10_categories_90d (category_id);

-- TOP 10 정렬 조회 최적화를 위한 내림차순 인덱스
CREATE INDEX idx_mv_top10_cat_qty 
ON mv_top10_categories_90d (total_qty DESC);

-- 서비스 중단 없이 데이터 갱신
REFRESH MATERIALIZED VIEW CONCURRENTLY mv_top10_categories_90d;

-- 실행 계획 확인
EXPLAIN (ANALYZE, BUFFERS)
SELECT 
    category_id,
    category_name,
    total_qty AS "총 주문 수량"
FROM mv_top10_categories_90d
ORDER BY total_qty DESC
LIMIT 10;