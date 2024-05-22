resource "aiven_kafka_connector" "kafka_connector" {
  project        = var.project_name
  service_name   = var.service_name
  connector_name = var.connector_name
  config         = var.config
}
