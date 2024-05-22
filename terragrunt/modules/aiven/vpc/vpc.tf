resource "aiven_project_vpc" "vpc" {
  project      = var.project_name
  cloud_name   = var.cloud_name
  network_cidr = var.network_cidr

  timeouts {
    create = "5m"
  }
}
