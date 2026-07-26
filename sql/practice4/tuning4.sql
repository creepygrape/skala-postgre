-- 제품별 누적 매출 Materialized View
CREATE MATERIALIZED VIEW mv_product_cum_sales AS
SELECT 
    p.product_id,
    p.product_name,
    SUM(oi.line_total) AS total_sales
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
JOIN products p ON oi.product_id = p.product_id
WHERE o.order_status IN ('paid', 'shipped', 'delivered')
GROUP BY p.product_id, p.product_name;

CREATE UNIQUE INDEX idx_mv_prod_sales_id ON mv_product_cum_sales (product_id);
CREATE INDEX idx_mv_prod_sales_total ON mv_product_cum_sales (total_sales DESC);

EXPLAIN (ANALYZE, BUFFERS)
SELECT 
    RANK() OVER (ORDER BY total_sales DESC) AS "순위",
    product_id AS "제품 ID",
    product_name AS "제품명",
    total_sales AS "총 누적 매출"
FROM mv_product_cum_sales
ORDER BY total_sales DESC
LIMIT 20;