output "project_id" {
  value = google_project.project.project_id
}

output "gcr_bucket_id" {
  value = var.create_container_registry ? google_container_registry.registry[0].id : null
}

output "app_engine_default_service_account_email" {
  value = data.google_app_engine_default_service_account.project.email
}
