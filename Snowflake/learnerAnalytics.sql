USE DATABASE LEARNCO;

USE SCHEMA GOLD_ANALYTICS;

-- a) Low Completion (<40%) but High Score (>70)

SELECT 
    course_id,
    course_name,
    completion_rate,
    avg_score,
    avg_time_spent_hours
FROM COURSE_PERFORMANCE
WHERE completion_rate < 0.4
  AND avg_score > 70;

-- b) Avg Score by Difficulty & Subscription

SELECT 
    c.difficulty_level,
    s.subscription_type,
    AVG(a.score) AS avg_score
FROM ASSESSMENTS a
JOIN COURSES c ON a.course_id = c.course_id
JOIN STUDENTS s ON a.student_id = s.student_id
GROUP BY c.difficulty_level, s.subscription_type
ORDER BY c.difficulty_level, s.subscription_type;

-- c) Students with High Enrollment but Low Completion

-- SELECT 
--     a.student_id,
--     s.subscription_type,
--     DATE_TRUNC('MONTH', a.enrollment_date) AS month,
--     COUNT(a.course_id) AS courses_enrolled,
--     SUM(CASE WHEN a.completion_status = 'Completed' THEN 1 ELSE 0 END) AS courses_completed
-- FROM ASSESSMENTS a
-- JOIN STUDENTS s ON a.student_id = s.student_id
-- GROUP BY a.student_id, s.subscription_type, DATE_TRUNC('MONTH', a.enrollment_date)
-- HAVING COUNT(a.course_id) >= 3
--    AND (SUM(CASE WHEN a.completion_status = 'Completed' THEN 1 ELSE 0 END) 
--         / COUNT(a.course_id)) < 0.3;

SELECT 
    a.student_id,
    s.subscription_type,
    DATE_TRUNC('MONTH', a.enrollment_date) AS month,
    COUNT(a.course_id) AS courses_enrolled,
    SUM(CASE WHEN a.completion_status = 'Completed' THEN 1 ELSE 0 END) AS courses_completed
FROM ASSESSMENTS a
JOIN STUDENTS s ON a.student_id = s.student_id
GROUP BY a.student_id, s.subscription_type, DATE_TRUNC('MONTH', a.enrollment_date)
HAVING COUNT(a.course_id) >= 3
   AND (SUM(CASE WHEN a.completion_status = 'Completed' THEN 1 ELSE 0 END) * 1.0
        / COUNT(a.course_id)) < 0.3;


-- d) Rank Instructors by Completion Rate

SELECT 
    c.category,
    c.instructor_id,
    COUNT(c.course_id) AS course_count,
    AVG(cp.completion_rate) AS avg_completion_rate,
    AVG(cp.avg_feedback_rating) AS avg_feedback_rating,
    RANK() OVER (
        PARTITION BY c.category 
        ORDER BY AVG(cp.completion_rate) DESC
    ) AS rank
FROM COURSE_PERFORMANCE cp
JOIN COURSES c ON cp.course_id = c.course_id
GROUP BY c.category, c.instructor_id;
