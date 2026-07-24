-- Q5) 고객이 얼마나 최근에, 얼마나 자주, 얼마나 많이 샀는지(최근성/빈도/금액)
-- customers -> orders -> order_items
-- orders에서 최근 구매일과 빈도
-- order_items에서 금액
WITH recent_orders AS (
    -- 1단계: 최근 30일 내의 유효한 주문 정보만 미리 필터링
    SELECT 
        o.customer_id,
        o.order_id,
        o.order_ts
    FROM orders o
    WHERE order_status in ('paid', 'shipped', 'delivered')
    AND o.order_ts >= CURRENT_DATE - INTERVAL '30 days'
),
recent_rfm AS (
    -- 2단계: 30일 내 데이터를 바탕으로 빈도(Frequency)와 금액(Monetary) 집계
    SELECT 
        ro.customer_id,
        COUNT(DISTINCT ro.order_id) AS order_frequency_30d,
        SUM(oi.line_total) AS total_amount_30d
    FROM recent_orders ro
    INNER JOIN order_items oi ON ro.order_id = oi.order_id
    GROUP BY ro.customer_id
),
all_last_order AS (
    -- 3단계: 고객별 '전체 기간' 중 가장 최근 구매일(Recency) 구하기
    SELECT 
        customer_id,
        MAX(order_ts) AS last_order_date
    FROM orders
    WHERE order_status IN ('paid', 'shipped', 'delivered')
    GROUP BY customer_id
)
-- 4단계: 최종 조합 (모든 고객을 기준으로 30일 데이터와 전체 최근 구매일 결합)
SELECT 
    c.customer_id AS "고객 번호",
    TO_CHAR(alo.last_order_date, 'YYYY-MM-DD HH24:MI:SS') AS "마지막 구매일",
    COALESCE(rf.order_frequency_30d, 0) AS "최근 30일 총 주문건수",
    COALESCE(rf.total_amount_30d, 0) AS "최근 30일 총 구매액"
FROM customers c
LEFT JOIN all_last_order alo ON c.customer_id = alo.customer_id
LEFT JOIN recent_rfm rf ON c.customer_id = rf.customer_id
ORDER BY c.customer_id ASC;
