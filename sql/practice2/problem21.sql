-- 문제 21
-- student 테이블에는 학과(major)와 GPA가 있습니다.
-- 학과별·GPA 구간별 인원을 집계하되,
-- 소계(소계행)와 총계 행까지 한 번의 쿼리로 아래의 내용이 반영되도록 출력
-- 1. GPA를 구간 (3.0 미만 / 3.0~3.5 / 3.5 초과)으로 분류하는 파생 컬럼을 추가
-- 2. GROUP BY ROLLUP(major, gpa_tier)로 학과별, 전체 소계를 동시에 조회
-- 3. GROUPING(major) 함수로 소계 행에 '전체' 라벨을 붙일 것
-- 4. 결과를 major, gpa_tier 순으로 정렬하되 소계 행은 하단에 표시
SELECT
    CASE GROUPING(major) WHEN 1 THEN '전체' -- NULL -> 전체
        ELSE major
    END as major,
    CASE GROUPING(gpa_tier) WHEN 1 THEN '소계' -- NULL -> 소계
        ELSE gpa_tier
    END as gpa_tier,
    COUNT(*) AS cnt,
    AVG(gpa)::NUMERIC(4, 2) AS avg_gpa
FROM (
    -- GPA 구간별 파생컬럼
    SELECT
        *,
        CASE WHEN gpa < 3.0 THEN 'C'
            WHEN gpa <= 3.5 THEN 'B'
            ELSE 'A'
        END as gpa_tier
    FROM student
) t
GROUP BY ROLLUP(major, gpa_tier)
-- 일반 데이터 -> 학과별 소계 -> 전체 총합
ORDER BY GROUPING(major), major, GROUPING(gpa_tier), gpa_tier
LIMIT 5;