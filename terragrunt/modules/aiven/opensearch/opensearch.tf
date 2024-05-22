resource "aiven_opensearch" "opensearch" {
  project                 = var.project_name
  cloud_name              = "google-europe-west1"
  plan                    = var.plan
  service_name            = var.service_name
  maintenance_window_dow  = "monday"
  maintenance_window_time = "07:00:00"
  project_vpc_id          = var.project_vpc_id
  termination_protection  = var.termination_protection

  opensearch_user_config {
    opensearch_version = var.opensearch_version

    opensearch_dashboards {
      enabled                    = true
      opensearch_request_timeout = 30000
    }

    public_access {
      opensearch            = true
      opensearch_dashboards = true
    }
  }
}
