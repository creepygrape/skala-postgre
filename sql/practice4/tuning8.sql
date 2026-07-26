-- 1) 리뷰 4.5 이상 & 50개 이상 조건의 효자상품을 집계하는 Materialized View 생성
CREATE MATERIALIZED VIEW mv_hero_products AS
SELECT
  p.product_id AS product_id,
  p.product_name AS product_name,
  COUNT(r.review_id) AS cnt_review,
  ROUND(AVG(r.rating)::numeric, 2) AS avg_rating
FROM products p
JOIN reviews r ON r.product_id = p.product_id
GROUP BY p.product_id, p.product_name
HAVING COUNT(r.review_id) >= 50
   AND AVG(r.rating) >= 4.5;

-- 2) 조회 조건 및 동기화(CONCURRENTLY)를 위한 유니크 인덱스 생성
CREATE UNIQUE INDEX idx_mv_hero_products_id ON mv_hero_products (product_id);

EXPLAIN (ANALYZE, BUFFERS)
SELECT
  product_id AS "상품 번호",
  product_name AS "상품명",
  cnt_review AS "리뷰 개수",
  avg_rating AS "리뷰 평점"
FROM mv_hero_products
ORDER BY product_id;