-- 조건 자체를 boolean 표현식 인덱스로 생성
CREATE INDEX IF NOT EXISTS idx_inventory_reorder 
ON inventory (product_id) 
WHERE qty_on_hand < reorder_point;

SELECT
  p.product_id AS "상품 번호",
  p.product_name AS "상품명",
  i.qty_on_hand AS "현재 재고 수량",
  i.reorder_point AS "최소 재고 수량"
FROM products p
JOIN inventory i ON p.product_id = i.product_id
WHERE i.qty_on_hand < i.reorder_point
ORDER BY p.product_id;