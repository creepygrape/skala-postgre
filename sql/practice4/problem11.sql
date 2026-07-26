-- Q11) 0으로 나누어도 에러 안 나는 나눗셈 함수 써보기
-- → 안전하게 평균 계산하기 (0으로 나누기 방지)
CREATE OR REPLACE FUNCTION safe_div_zero(
    numerator NUMERIC,
    denominator NUMERIC
)
RETURNS NUMERIC AS $$
    SELECT numerator / NULLIF(denominator, 0);
$$ LANGUAGE SQL IMMUTABLE STRICT;

SELECT
  safe_div(100, 0), -- 기존 코드
  safe_div_zero(100, 0); -- 새 코드