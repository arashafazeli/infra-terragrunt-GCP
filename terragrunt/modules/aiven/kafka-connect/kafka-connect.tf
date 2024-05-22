resource "aiven_kafka_connect" "kafka_connect" {
  project                 = var.project_name
  cloud_name              = "google-europe-west1"
  plan                    = var.plan
  service_name            = var.service_name
  maintenance_window_dow  = "monday"
  maintenance_window_time = "08:00:00"
  project_vpc_id          = var.project_vpc_id
  termination_protection  = var.termination_protection
}

resource "aiven_service_integration" "kafka_connect" {
  project                  = var.project_name
  integration_type         = "kafka_connect"
  source_service_name      = var.source_service_name
  destination_service_name = var.service_name
  kafka_connect_user_config {
    kafka_connect {
      group_id             = "connect"
      status_storage_topic = "__connect_status"
      offset_storage_topic = "__connect_offsets"
    }
  }
}
