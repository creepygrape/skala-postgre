SELECT
  CASE 
    WHEN o.coupon_code IS NOT NULL THEN '쿠폰 사용'  
    ELSE '쿠폰 미사용'
  END AS "쿠폰 사용 여부",
  COUNT(o.order_id) AS "총 주문 건수",
  ROUND(AVG(oi.total_order_amount)::NUMERIC, 2) AS "평균 주문 금액"
FROM orders o
JOIN (
  -- order_items만 먼저 주문별로 합산 (orders와 조인 전)
  SELECT order_id, SUM(line_total) AS total_order_amount
  FROM order_items
  GROUP BY order_id
) oi ON oi.order_id = o.order_id
GROUP BY 
  CASE 
    WHEN o.coupon_code IS NOT NULL THEN '쿠폰 사용'  
    ELSE '쿠폰 미사용'
  END;