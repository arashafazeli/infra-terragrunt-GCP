output "name" {
  value = google_service_account.service_account.name
}

output "service_account" {
  value = "serviceAccount:${google_service_account.service_account.email}"
}

output "project" {
  value = data.google_client_config.get_project.project
}
