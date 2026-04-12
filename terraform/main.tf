provider "google" {
  project     = "sampleproject-492912"
  region      = "US"
  credentials = file("key.json")
}

# Dataset
resource "google_bigquery_dataset" "learnco" {
  dataset_id = "learnco_analytics"
  location   = "US"
}

# Course Performance Table
resource "google_bigquery_table" "course_performance" {
  dataset_id = google_bigquery_dataset.learnco.dataset_id
  table_id   = "course_performance"

  schema = file("course_performance_schema.json")

  deletion_protection = false
}

# Student Engagement Table (Partitioned)
resource "google_bigquery_table" "student_engagement" {
  dataset_id = google_bigquery_dataset.learnco.dataset_id
  table_id   = "student_engagement"

  schema = file("student_engagement_schema.json")

  deletion_protection = false

  time_partitioning {
    type  = "DAY"
    field = "registration_date"
  }
}