USE DATABASE LEARNCO;

CREATE SCHEMA IF NOT EXISTS ANALYTICS_DASHBOARD;
USE SCHEMA ANALYTICS_DASHBOARD;

CREATE OR REPLACE VIEW VW_LOW_COMPLETION_COURSES AS
SELECT 
    course_id,
    course_name,
    completion_rate,
    avg_score,
    avg_time_spent_hours
FROM LEARNCO.GOLD_ANALYTICS.COURSE_PERFORMANCE
WHERE completion_rate < 0.4
  AND avg_score > 70;


CREATE OR REPLACE VIEW VW_SCORE_BY_DIFFICULTY_SUBSCRIPTION AS
SELECT 
    c.difficulty_level,
    s.subscription_type,
    AVG(a.score) AS avg_score
FROM LEARNCO.GOLD_ANALYTICS.ASSESSMENTS a
JOIN LEARNCO.GOLD_ANALYTICS.COURSES c 
    ON a.course_id = c.course_id
JOIN LEARNCO.GOLD_ANALYTICS.STUDENTS s 
    ON a.student_id = s.student_id
GROUP BY c.difficulty_level, s.subscription_type;


CREATE OR REPLACE VIEW VW_AT_RISK_STUDENTS AS
SELECT 
    a.student_id,
    s.subscription_type,
    DATE_TRUNC('MONTH', a.enrollment_date) AS month,
    COUNT(a.course_id) AS courses_enrolled,
    SUM(CASE WHEN a.completion_status = 'Completed' THEN 1 ELSE 0 END) AS courses_completed
FROM LEARNCO.GOLD_ANALYTICS.ASSESSMENTS a
JOIN LEARNCO.GOLD_ANALYTICS.STUDENTS s 
    ON a.student_id = s.student_id
GROUP BY a.student_id, s.subscription_type, DATE_TRUNC('MONTH', a.enrollment_date)
HAVING COUNT(a.course_id) >= 3
   AND (SUM(CASE WHEN a.completion_status = 'Completed' THEN 1 ELSE 0 END) * 1.0
        / COUNT(a.course_id)) < 0.3;


CREATE OR REPLACE VIEW VW_INSTRUCTOR_RANKING AS
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
FROM LEARNCO.GOLD_ANALYTICS.COURSE_PERFORMANCE cp
JOIN LEARNCO.GOLD_ANALYTICS.COURSES c 
    ON cp.course_id = c.course_id
GROUP BY c.category, c.instructor_id;


SHOW VIEWS IN SCHEMA ANALYTICS_DASHBOARD;

SELECT * FROM VW_LOW_COMPLETION_COURSES;

SELECT * FROM VW_INSTRUCTOR_RANKING;