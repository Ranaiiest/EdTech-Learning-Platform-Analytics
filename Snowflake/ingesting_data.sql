USE DATABASE LEARNCO;

CREATE SCHEMA GOLD_ANALYTICS;

USE SCHEMA GOLD_ANALYTICS;

select * from courses limit 10;

CREATE OR REPLACE TABLE students (
    student_id STRING,
    first_name STRING,
    last_name STRING,
    email STRING,
    age INT,
    country STRING,
    registration_date DATE,
    subscription_type STRING,
    total_courses_enrolled INT,
    is_active BOOLEAN,
    account_age_days INT
);

CREATE OR REPLACE TABLE courses (
    course_id STRING,
    course_name STRING,
    category STRING,
    instructor_id STRING,
    duration_hours INT,
    difficulty_level STRING,
    price_usd DOUBLE,
    is_free BOOLEAN,
    rating DOUBLE,
    enrollment_count INT,
    published_date DATE,
    language STRING,
    has_certificate BOOLEAN,
    revenue_per_enrollment DOUBLE
);

CREATE OR REPLACE TABLE assessments (
    assessment_id STRING,
    student_id STRING,
    course_id STRING,
    enrollment_date DATE,
    completion_date DATE,
    completion_status STRING,
    score DOUBLE,
    time_spent_hours DOUBLE,
    quiz_attempts INT,
    certificate_issued BOOLEAN,
    feedback_rating INT,
    last_activity_date DATE,
    completion_days INT,
    pass_flag BOOLEAN
);

CREATE OR REPLACE TABLE course_performance (
    course_id STRING,
    course_name STRING,
    category STRING,
    total_enrollments BIGINT,
    completion_rate DECIMAL(6,5),
    avg_score DOUBLE,
    avg_time_spent_hours DOUBLE,
    avg_feedback_rating DOUBLE,
    certificate_issued_count BIGINT,
    drop_rate DECIMAL(6,5)
);

CREATE OR REPLACE TABLE student_engagement (
    student_id STRING,
    subscription_type STRING,
    country STRING,
    courses_enrolled BIGINT,
    courses_completed BIGINT,
    avg_score DOUBLE,
    total_time_spent_hours DOUBLE,
    certificates_earned BIGINT
);

CREATE OR REPLACE STAGE silver_stage
URL = 'azure://macrostorage123.blob.core.windows.net/edtech/edtech_export/silver'
CREDENTIALS = (
  AZURE_SAS_TOKEN = 'sp=racwdli&st=2026-04-11T06:24:56Z&se=2026-04-11T14:39:56Z&spr=https&sv=2025-11-05&sr=c&sig=WajWwm67KKtlxS1XphT6cT9nL20OYRl2zz%2F%2BTk9qQJc%3D'
)
FILE_FORMAT = (TYPE = PARQUET);

COPY INTO students
FROM @silver_stage/students/
FILE_FORMAT = (TYPE = PARQUET)
MATCH_BY_COLUMN_NAME = CASE_INSENSITIVE
PATTERN = '.*\\.parquet';

COPY INTO courses
FROM @silver_stage/courses/
FILE_FORMAT = (TYPE = PARQUET)
MATCH_BY_COLUMN_NAME = CASE_INSENSITIVE
PATTERN = '.*\\.parquet';

COPY INTO assessments
FROM @silver_stage/assessments/
FILE_FORMAT = (TYPE = PARQUET)
MATCH_BY_COLUMN_NAME = CASE_INSENSITIVE
PATTERN = '.*\\.parquet';

select * from students limit 10;

CREATE OR REPLACE STAGE gold_stage
URL = 'azure://macrostorage123.blob.core.windows.net/edtech/edtech_export/gold'
CREDENTIALS = (
  AZURE_SAS_TOKEN = 'sp=racwdli&st=2026-04-11T06:24:56Z&se=2026-04-11T14:39:56Z&spr=https&sv=2025-11-05&sr=c&sig=WajWwm67KKtlxS1XphT6cT9nL20OYRl2zz%2F%2BTk9qQJc%3D'
)
FILE_FORMAT = (TYPE = PARQUET);

COPY INTO course_performance
FROM @gold_stage/course_performance/
FILE_FORMAT = (TYPE = PARQUET)
MATCH_BY_COLUMN_NAME = CASE_INSENSITIVE
PATTERN = '.*\\.parquet';

COPY INTO student_engagement
FROM @gold_stage/student_engagement/
FILE_FORMAT = (TYPE = PARQUET)
MATCH_BY_COLUMN_NAME = CASE_INSENSITIVE
PATTERN = '.*\\.parquet';

select * from student_engagement limit 10;