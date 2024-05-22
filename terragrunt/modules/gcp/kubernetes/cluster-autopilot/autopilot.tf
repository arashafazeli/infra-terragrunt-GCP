resource "google_container_cluster" "autopilot" {
  name             = var.name
  description      = var.description
  location         = var.location
  enable_autopilot = true

  master_auth {
    client_certificate_config {
      issue_client_certificate = true
    }
  }

}
