output "name" {
  value = google_service_account.service_account.name
}

output "service_account" {
  value = "serviceAccount:${google_service_account.service_account.email}"
}

output "credentials" {
  value     = base64decode(google_service_account_key.service_account_key.private_key)
  sensitive = true
}

output "project" {
  value = data.google_client_config.get_project.project
}
