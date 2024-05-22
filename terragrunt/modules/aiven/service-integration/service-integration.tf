resource "aiven_service_integration" "integration" {
  project                 = var.project
  destination_endpoint_id = var.destination_endpoint_id
  integration_type        = var.integration_type
  source_service_name     = var.source_service_name
}