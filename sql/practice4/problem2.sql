-- Q2) 월별 주문건수와 총 매출, 주문당 평균 금액 구하기
-- paid, shipped, delivered, refunded는 payments.amount 기록 존재
-- 주문건수, 주문당 평균 금액은 order_status 조건 없이 카운트
-- 총 매출 = paid + shipped + delivered
SELECT
    EXTRACT(YEAR FROM order_ts) || '-'|| EXTRACT(MONTH FROM order_ts) AS "연-월",
    COUNT(o.order_id) AS "주문건수",
    SUM(
        CASE 
            WHEN o.order_status IN ('paid', 'shipped', 'delivered') THEN p.amount 
            ELSE 0 
        END
    ) AS "총 매출",
    AVG(p.amount)::NUMERIC(10, 2)  AS "주문당 평균 금액"
FROM orders o
LEFT JOIN payments p ON o.order_id = p.order_id -- 결제 기록이 없는 컬럼도 카운트하기 위해 LEFT JOIN
GROUP BY
    EXTRACT(YEAR FROM order_ts),
    EXTRACT(MONTH FROM order_ts)
ORDER BY
    "연-월";