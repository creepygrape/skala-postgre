
CREATE MATERIALIZED VIEW IF NOT EXISTS monthly_sales_summary AS
SELECT
    DATE_TRUNC('month', o.order_ts) AS month,
    COUNT(o.order_id) AS order_count,
    SUM(p.amount)
        FILTER (
            WHERE o.order_status IN ('paid', 'shipped', 'delivered')
        ) AS total_sales,
    AVG(p.amount)::NUMERIC(10, 2) AS avg_order_amount
FROM orders o
LEFT JOIN payments p
    ON o.order_id = p.order_id
GROUP BY DATE_TRUNC('month', o.order_ts);

CREATE UNIQUE INDEX idx_monthly_sales_summary_month
ON monthly_sales_summary(month);
REFRESH MATERIALIZED VIEW CONCURRENTLY monthly_sales_summary;

-- 성능 분석 대상: Materialized View 조회 쿼리
EXPLAIN (ANALYZE, BUFFERS)
SELECT
    TO_CHAR(month, 'YYYY-MM') AS "연-월",
    order_count AS "주문건수",
    total_sales AS "총 매출",
    avg_order_amount AS "주문당 평균 금액"
FROM monthly_sales_summary
ORDER BY month;