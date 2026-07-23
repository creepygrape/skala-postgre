-- 문제 24
-- enroll 테이블을 student_id 기준으로 정렬하고,
-- 각 학생의 이전 수강 과목 대비 성적 변화를 LAG()로 계산
-- (성적은 A=4, B=3, C=2, D=1 점수로 변환)
-- 1. grade를 숫자 점수(A=4, B=3, C=2, D=1)로 변환하는 CASE 식을 작성
-- 2. LAG(score) OVER (PARTITION BY student_id ORDER BY course)로 이전 과목 점수를 가져올 것
-- 3. 현재 점수 - 이전 점수를 diff 컬럼으로 추가하고, 상승/유지/하락을 텍스트로 표시
-- 4. 학생별 최고점과 최저점의 차이(score_range)를 Window Function으로 계산
with scored as (
    SELECT
        student_id,
        course,
        grade,
        CASE grade WHEN 'A' THEN 4
            WHEN 'B' THEN 3
            WHEN 'C' THEN 2
            ELSE 1
        END as score
    FROM enroll
),
lagged as (
    SELECT
        *,
        LAG(score) OVER (PARTITION BY student_id ORDER BY course) as prev_score,
        MAX(score) OVER (PARTITION BY student_id) - MIN(score) OVER(PARTITION BY student_id) as score_range
    FROM scored
)
SELECT
    *,
    score - prev_score as diff,
    CASE WHEN score > prev_score THEN '상승'
        WHEN score = prev_score THEN '유지'
        ELSE '하락'
    END as trend
FROM lagged;
