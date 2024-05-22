resource "aiven_elasticsearch" "elasticsearch" {
  project                 = var.project_name
  cloud_name              = "google-europe-west1"
  plan                    = var.plan
  service_name            = var.service_name
  maintenance_window_dow  = "monday"
  maintenance_window_time = "06:00:00"
  project_vpc_id          = var.project_vpc_id
  termination_protection  = var.termination_protection

  elasticsearch_user_config {
    elasticsearch_version = var.elasticsearch_version

    kibana {
      enabled                       = true
      elasticsearch_request_timeout = 30000
    }

    public_access {
      elasticsearch = false
      kibana        = false
    }
  }
}