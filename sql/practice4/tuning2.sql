SELECT
    EXTRACT(YEAR FROM o.order_ts) || '-' || LPAD(EXTRACT(MONTH FROM o.order_ts)::TEXT, 2, '0') AS "연-월",
    
    -- 1. 주문 건수는 상태 조건 없이 전체 주문 카운트
    COUNT(o.order_id) AS "주문건수",
    
    -- 2. 총 매출 = paid, shipped, delivered 상태인 주문의 결제금액 합산
    SUM(
        CASE 
            WHEN o.order_status IN ('paid', 'shipped', 'delivered') THEN p.amount 
            ELSE 0 
        END
    ) AS "총 매출",
    
    -- 3. 주문당 평균 금액
    AVG(p.amount)::NUMERIC(10, 2) AS "주문당 평균 금액"
FROM orders o
LEFT JOIN payments p ON o.order_id = p.order_id
GROUP BY
    EXTRACT(YEAR FROM o.order_ts),
    EXTRACT(MONTH FROM o.order_ts)
ORDER BY
    "연-월";