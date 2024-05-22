resource "aiven_kafka" "kafka" {
  project                 = var.project_name
  cloud_name              = "google-europe-west1"
  plan                    = var.plan
  service_name            = var.service_name
  maintenance_window_dow  = "monday"
  maintenance_window_time = "06:00:00"
  project_vpc_id          = var.project_vpc_id
  termination_protection  = var.termination_protection

  kafka_user_config {
    kafka_rest      = true
    kafka_connect   = var.kafka_connect
    schema_registry = false
    kafka_version   = var.kafka_version

    kafka {
      log_retention_bytes = 1209600000
    }
    public_access {
      kafka_rest    = var.kafka_rest
      kafka         = true
      kafka_connect = var.kafka_connect_public
    }
  }
}

resource "aiven_kafka_user" "user" {
  service_name = var.service_name
  project      = var.project_name
  username     = "admin"
}
