-- Q6) 첫 구매 후 30일 내 재구매율
-- 1단계: 고객별 첫 구매
WITH first_order AS (
    SELECT
        customer_id,
        MIN(order_ts) AS first_order_date
    FROM orders
    WHERE order_status in ('paid', 'shipped', 'delivered')
    GROUP BY customer_id
),
-- 2단계: 첫 구매 후 30일 데이터
recent_first_order AS (
    SELECT
        fo.customer_id,
        fo.first_order_date,
        COUNT(CASE WHEN o.order_ts > fo.first_order_date
            AND o.order_ts <= fo.first_order_date + INTERVAL '30 days'
            THEN o.order_id
        END) AS repurchase_count_30d
    FROM first_order fo
    JOIN orders o
        ON fo.customer_id = o.customer_id
    GROUP BY fo.customer_id, fo.first_order_date
)
-- 3단계: 첫 구매 고객 수 대비 30일 내 재구매 고객 수 비율 산출
SELECT
    COUNT(customer_id) AS "구매 이력이 존재하는 고객 수",
    SUM(CASE WHEN repurchase_count_30d > 0 THEN 1 ELSE 0 END) AS "30일 내 재구매 고객 수",
    ROUND(
        SUM(CASE WHEN repurchase_count_30d > 0 THEN 1 ELSE 0 END)::NUMERIC
        / NULLIF(COUNT(customer_id), 0) * 100,
        2
    ) AS "30일 내 재구매율 (%)"
FROM recent_first_order;


-- 가입 월별 재구매율
-- WITH monthly_orders AS (
-- SELECT customer_id, DATE_TRUNC('month'
-- , order_date) AS order_month
-- FROM orders
-- ),
-- first_order AS (
-- SELECT customer_id, MIN(order_month) AS cohort_month
-- FROM monthly_orders GROUP BY customer_id
-- )
-- SELECT fo.cohort_month,
-- mo.order_month,
-- COUNT(DISTINCT fo.customer_id) AS customers,
-- EXTRACT(MONTH FROM AGE(mo.order_month, fo.cohort_month)) AS months_after
-- FROM first_order fo JOIN monthly_orders mo USING(customer_id)
-- GROUP BY 1, 2 ORDER BY 1, 2;