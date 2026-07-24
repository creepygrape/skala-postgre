WITH product_sales AS (
    -- 1단계: 주문 테이블을 먼저 유효 상태로 필터링하고 필요한 컬럼만 조인하여 집계 부하 최소화
    SELECT 
        oi.product_id,
        SUM(oi.line_total) AS total_revenue
    FROM orders o
    INNER JOIN order_items oi ON o.order_id = oi.order_id
    WHERE o.order_status IN ('paid', 'shipped', 'delivered')
    GROUP BY oi.product_id
),
ranked_products AS (
    -- 2단계: 집계된 결과에 RANK()를 적용하여 순위 부여
    SELECT 
        RANK() OVER (ORDER BY ps.total_revenue DESC) AS ranking,
        ps.product_id,
        ps.total_revenue
    FROM product_sales ps
)
-- 3단계: 상위 20위(공동 순위 포함)를 가져온 뒤, 상품 마스터 테이블과 조인하여 이름 획득
SELECT 
    rp.ranking AS "순위",
    p.product_id AS "제품 ID",
    p.product_name AS "제품명",
    rp.total_revenue AS "총 누적 매출"
FROM ranked_products rp
INNER JOIN products p ON rp.product_id = p.product_id
WHERE rp.ranking <= 20
ORDER BY rp.ranking ASC;