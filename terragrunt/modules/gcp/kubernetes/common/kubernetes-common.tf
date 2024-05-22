locals {
  oauth_client_name = "kubernetes-isc-${data.google_client_config.current.project}"
}

resource "random_password" "password" {
  length           = 16
  special          = true
  override_special = "_%@"
}

resource "gloot_oauth_client" "client" {
  user_id = local.oauth_client_name
  secrets = [random_password.password.result]
}

module "oauth-client-secret" {
  source = "./secret"
  name   = "core-common-oauth-client-secret"
  data = {
    username = gloot_oauth_client.client.user_id
    secret   = gloot_oauth_client.client.secrets[0]
  }
  service_name = var.service_name
  product      = var.product
  team         = var.team
}
