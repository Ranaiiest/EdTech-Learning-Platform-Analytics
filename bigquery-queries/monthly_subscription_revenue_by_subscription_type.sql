SELECT
  subscription_type,
  COUNT(*) AS users,

  CASE
    WHEN subscription_type = 'Monthly' THEN COUNT(*) * 20
    WHEN subscription_type = 'Annual' THEN COUNT(*) * (200 / 12)
    WHEN subscription_type = 'Free' THEN 0
    WHEN subscription_type = 'Enterprise' THEN COUNT(*) * 50
  END AS estimated_monthly_revenue

FROM `sampleproject-492912.learnco_analytics.student_engagement`
GROUP BY subscription_type;