resource "random_password" "password" {
  length           = 16
  special          = true
  override_special = "_%@"
}

resource "aiven_service_integration_endpoint" "prometheus" {
  project       = var.project
  endpoint_name = var.name
  endpoint_type = "prometheus"

  prometheus_user_config {
    basic_auth_username = var.username
    basic_auth_password = random_password.password.result
  }
}