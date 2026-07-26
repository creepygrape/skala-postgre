SELECT
    SUM(gmv) AS total_amount
FROm mv_daily_gmv
WHERE day >= CURRENT_DATE - INTERVAL '1 month'
    AND day <= CURRENT_DATE;
