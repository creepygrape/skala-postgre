WITH filtered_orders AS (
    -- 1단계: 지난 한 달간의 특정 상태 주문만 추출
    SELECT order_id, order_status, order_ts
    FROM orders
    WHERE order_ts >= NOW() - INTERVAL '1 month'
      AND order_ts <= NOW()
      AND order_status IN ('paid', 'shipped', 'delivered')
),
valid_payments AS (
    -- 2단계: 위에서 필터링된 '한 달 내 주문(filtered_orders)'에 속하는 결제 내역의 금액만 추출
    SELECT
        p.order_id,
        p.amount
    FROM payments p
    INNER JOIN filtered_orders fo ON p.order_id = fo.order_id
)
-- 3단계: 결제 금액을 합산
SELECT
    SUM(amount) AS total_amount
FROM valid_payments vp;