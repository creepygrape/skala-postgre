-- 문제 23
-- 각 학과(major)별로 GPA가 높은 순서로 순위를 매기고,
-- 상위 3명씩만 추출하는 쿼리를 Window Function으로 작성
-- (서브쿼리 방식과 CTE 방식 모두 작성)
-- 1. 학과 내 순위를 계산
--   ROW_NUMBER() OVER (PARTITION BY major ORDER BY gpa DESC)
-- 2. GPA가 동일한 경우 student_id 오름차순을 2차 기준으로 사용
-- 3. RANK()와 DENSE_RANK()를 함께 계산해 동점 처리 방식 차이를 비교
-- 4. 결과에 전체 학과별 학생 수(total_in_major)도 COUNT() OVER(PARTITION BY major)로 추가
-- CTE
with ranked as (
    SELECT
        student_id,
        name,
        major,
        gpa,
        ROW_NUMBER() OVER (PARTITION BY major ORDER BY gpa DESC, student_id) as rn, -- 학과 내 순위
        RANK() OVER (PARTITION BY major ORDER BY gpa DESC) as rnk,
        DENSE_RANK() OVER (PARTITION BY major ORDER BY gpa DESC) AS drk,
        COUNT(*) OVER (PARTITION BY major) AS total_in_major
    FROM student
)
SELECT
    *
FROM ranked
WHERE rn <= 3
ORDER BY major, rn;

-- 서브쿼리
SELECT
    *
FROM (
    SELECT
        student_id,
        name,
        major,
        gpa,
        ROW_NUMBER() OVER (PARTITION BY major ORDER BY gpa DESC, student_id) as rn,
        RANK() OVER (PARTITION BY major ORDER BY gpa DESC) as rnk,
        DENSE_RANK() OVER (PARTITION BY major ORDER BY gpa DESC) AS drk,
        COUNT(*) OVER (PARTITION BY major) AS total_in_major
    FROM student
) ranked
WHERE rn <= 3
ORDER BY major, rn;