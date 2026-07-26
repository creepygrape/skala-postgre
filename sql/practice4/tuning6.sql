WITH customer_orders AS (
    SELECT 
        customer_id,
        order_id,
        order_ts,
        -- 고객별 최초 구매 시각을 단일 스캔으로 바로 구함
        MIN(order_ts) OVER (PARTITION BY customer_id) AS first_order_ts
    FROM orders
    WHERE order_status IN ('paid', 'shipped', 'delivered')
),
customer_metrics AS (
    SELECT 
        customer_id,
        -- 첫 구매일 이후 30일 이내에 일어난 재구매 건이 1건이라도 있는지 확인
        COUNT(CASE 
            WHEN order_ts > first_order_ts 
             AND order_ts <= first_order_ts + INTERVAL '30 days' 
            THEN order_id 
        END) AS repurchase_cnt_30d
    FROM customer_orders
    GROUP BY customer_id
)
SELECT
    COUNT(customer_id) AS "구매 이력이 존재하는 고객 수",
    COUNT(CASE WHEN repurchase_cnt_30d > 0 THEN 1 END) AS "30일 내 재구매 고객 수",
    ROUND(
        COUNT(CASE WHEN repurchase_cnt_30d > 0 THEN 1 END)::NUMERIC 
        / NULLIF(COUNT(customer_id), 0) * 100, 
        2
    ) AS "30일 내 재구매율 (%)"
FROM customer_metrics;