-- Q9) 쿠폰 사용 영향(쿠폰을 쓴 주문과 안 쓴 주문의 평균 주문 금액 비교)
WITH order_totals AS (
  SELECT
    o.order_id,
    o.coupon_code,
    SUM(oi.line_total) aS total_order_amount
  FROM orders o
  JOIN order_items oi
    ON oi.order_id = o.order_id
  GROUP BY o.order_id, o.coupon_code
)
SELECT
  CASE 
    WHEN coupon_code IS NOT NULL THEN '쿠폰 사용'  
    ELSE '쿠폰 미사용'
  END AS "쿠폰 사용 여부",
  COUNT(order_id) as "총 주문 건수",
  AVG(total_order_amount)::NUMERIC(10, 2) AS "평균 주문 금액"
FROM order_totals
GROUP BY
  CASE 
    WHEN coupon_code IS NOT NULL THEN '쿠폰 사용'  
    ELSE '쿠폰 미사용'
  END;