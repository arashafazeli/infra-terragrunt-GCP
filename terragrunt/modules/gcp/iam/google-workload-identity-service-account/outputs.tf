output "name" {
  value = google_service_account.service_account.name
}

output "service_account" {
  value = "serviceAccount:${google_service_account.service_account.email}"
}

output "email" {
  value = google_service_account.service_account.email
}
