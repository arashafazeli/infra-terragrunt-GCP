resource "google_compute_global_address" "ip_address" {
  provider = google-beta
  name     = var.name
  labels   = var.labels
}

