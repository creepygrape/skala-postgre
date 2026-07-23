-- 문제 25
-- orders 테이블의 주문을 order_id 순으로 정렬하여 누적 주문금액과 3개 주문 이동평균 계산 (ROWS BETWEEN 사용)
-- 1. SUM(amount) OVER (ORDER BY order_id ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW)로 누적합 계산
-- 2. AVG(amount) OVER (ORDER BY order_id ROWS BETWEEN 2 PRECEDING AND CURRENT ROW)로 3개 이동평균 계산
-- 3. customer_id별로 PARTITION을 나눠 고객별 누적 구매금액도 함께 계산
-- 4. 누적합이 전체 합의 50%를 초과하는 첫 번째 order_id를 찾는 쿼리를 작성
WITH total_orders as (
    SELECT SUM(amount) as total_sum
    FROM orders
),
order_stats AS (
    SELECT
        order_id,
        customer_id,
        amount,
        SUM(amount) OVER (ORDER BY order_id ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) as cum_total,
        AVG(amount) OVER (ORDER BY order_id ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) as moving_avg_3,
        SUM(amount) OVER (PARTITION BY customer_id ORDER BY order_id ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) as cust_cum
    FROM orders
)
SELECT
    s.order_id,
    s.customer_id,
    s.amount,
    s.cum_total,
    s.moving_avg_3,
    s.cust_cum
FROM order_stats s
CROSS JOIN total_orders t
WHERE s.cum_total >= t.total_sum * 0.5
ORDER BY s.order_id
LIMIT 1;