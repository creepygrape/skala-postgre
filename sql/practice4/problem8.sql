-- Q8) 리뷰 4.5↑ & 50개↑ 효자상품 (리뷰가 많고 평가도 좋은 효자상품 찾기)
WITH good_reviews AS (
  SELECT
    product_id,
    AVG(rating)::NUMERIC(10, 2) AS avg_rating,
    COUNT(review_id) AS cnt_review
  FROM reviews
  GROUP BY product_id
)
SELECT
  p.product_id AS "상품 번호",
  p.product_name AS "상품명",
  gr.cnt_review AS "리뷰 개수",
  gr.avg_rating AS "리뷰 평점"
FROM products p
JOIN good_reviews gr
  ON gr.product_id = p.product_id
WHERE gr.avg_rating >= 4.5
  AND gr.cnt_review >= 50
ORDER BY p.product_id;