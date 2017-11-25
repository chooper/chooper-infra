resource "google_sql_database_instance" "primary" {
  name             = "primary-db"
  region           = "us-west1"
  database_version = "POSTGRES_9_6"

  settings {
    tier = "db-f1-micro"
  }
}
