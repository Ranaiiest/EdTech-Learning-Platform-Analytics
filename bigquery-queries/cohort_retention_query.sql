WITH base AS (
  SELECT
    student_id,
    DATE_TRUNC(registration_date, MONTH) AS cohort_month,
    DATE_TRUNC(CURRENT_DATE(), MONTH) AS activity_month,
    courses_completed
  FROM `sampleproject-492912.learnco_analytics.student_engagement`
),

cohort_size AS (
  SELECT
    cohort_month,
    COUNT(DISTINCT student_id) AS total_users
  FROM base
  GROUP BY cohort_month
),

active_users AS (
  SELECT
    cohort_month,
    activity_month,
    COUNT(DISTINCT student_id) AS active_users
  FROM base
  WHERE courses_completed > 0
  GROUP BY cohort_month, activity_month
)

SELECT
  a.cohort_month,
  a.activity_month,
  a.active_users,
  c.total_users,
  ROUND(a.active_users * 100.0 / c.total_users, 2) AS retention_rate
FROM active_users a
JOIN cohort_size c
ON a.cohort_month = c.cohort_month
ORDER BY cohort_month;