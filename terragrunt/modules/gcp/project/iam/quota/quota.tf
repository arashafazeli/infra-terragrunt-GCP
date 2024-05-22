data "google_project" "project" {
}

resource "google_service_usage_consumer_quota_override" "override" {
  provider       = google-beta
  service        = var.service
  metric         = var.metric
  limit          = var.limit
  override_value = var.override_value
  project        = var.project != "" ? var.project : data.google_project.project.project_id
  dimensions     = var.dimensions
  force          = var.force
}
