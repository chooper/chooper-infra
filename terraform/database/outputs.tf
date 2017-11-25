output "name" {
  value = "${google_sql_database_instance.primary.name}"
}

output "ip_address" {
  value = "${google_sql_database_instance.primary.ip_address.0.ip_address}"
}

output "ip_time_to_retire" {
  value = "${google_sql_database_instance.primary.ip_address.0.time_to_retire}"
}

output "self_link" {
  value = "${google_sql_database_instance.primary.self_link}"
}
