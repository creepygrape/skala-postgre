-- 문제 22
-- emp 테이블은 CEO(manager_id = NULL) → 매니저(10명) → 개발자(300명)의 3단계 계층 구조
-- WITH RECURSIVE로 모든 직원의 계층 경로와 깊이를 출력
-- 1. WITH RECURSIVE로 CEO에서 시작하는 조직 트리를 탐색
-- 2. 각 행에 depth(0=CEO), path 컬럼을 포함(예: 'CEO > Mgr_2 > Dev_15')
-- 3. 매니저별 직속 부하 직원 수를 집계하는 쿼리 별도로 작성 (컬럼명 : direct_reports)
-- 조직도 : 최상위 -> 최하위 전체 탐색
WITH RECURSIVE org_tree as (
    -- 최상위 관리자 (manager_id is NULL)
    SELECT
        emp_id,
        name,
        manager_id,
        0 as depth,
        name::TEXT as path
    FROM emp
    WHERE manager_id IS NULL
    UNION ALL

    -- 재귀 단계: 하위 직원 추가
    SELECT
        e.emp_id,
        e.name,
        e.manager_id,
        ot.depth + 1,
        ot.path || ' > ' || e.name
    FROM emp e
    JOIN org_tree ot ON ot.emp_id = e.manager_id
    WHERE ot.depth < 10 -- 무한 재귀 방지 !!! 항상 필요 !!!
),
direct_count AS (
    -- 매니저별 직속 부하 직원 수 집계
    SELECT
        manager_id,
        COUNT(*) AS cnt
    FROM emp
    WHERE manager_id IS NOT NULL
    GROUP BY manager_id
)
SELECT
    depth,
    REPEAT(' ', depth - 1) || name AS indented_name,
    path,
    dc.cnt as direct_reports
FROM org_tree
LEFT JOIN direct_count dc ON dc.manager_id = org_tree.emp_id
ORDER BY path;