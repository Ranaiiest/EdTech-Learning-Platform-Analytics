SELECT
  course_id,
  course_name,
  total_enrollments,

  total_enrollments AS enrollment_count,

  ROUND(total_enrollments * (1 - drop_rate)) AS started_count,

  ROUND(total_enrollments * completion_rate * 0.5) AS halfway_count,

  ROUND(total_enrollments * completion_rate) AS completed_count,

  100 AS enrollment_pct,

  ROUND((1 - drop_rate) * 100, 2) AS started_pct,

  ROUND(completion_rate * 50 * 100, 2) AS halfway_pct,

  ROUND(completion_rate * 100, 2) AS completed_pct

FROM `sampleproject-492912.learnco_analytics.course_performance`
ORDER BY total_enrollments DESC;