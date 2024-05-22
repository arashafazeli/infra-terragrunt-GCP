locals {
  # Some logic to handle env variable for both old dev, prod and new tech-folder
  env               = length(regexall("/live/tech/(.*?)/", abspath(path.root))) > 0 ? regex("/live/tech/(.*?)/", abspath(path.root))[0] : regex("/live/(.*?)/", abspath(path.root))[0]
  oauth_client_name = format("github-game-config-%s", random_id.name.hex)
}

# refresh_token
module "gloot-service-account" {
  source         = "./gloot-service-account"
  name           = var.github_repository_name
  roles          = var.gloot_roles
  refresh_tokens = var.gloot_refresh_tokens
}

resource "github_actions_secret" "refresh_token" {
  repository      = var.github_repository_name
  secret_name     = upper(replace("${local.env}_refresh_token", "-", "_"))
  plaintext_value = values(module.gloot-service-account.refresh_token)[0]
}

# oauth secrets
resource "random_id" "name" {
  byte_length = 2
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

resource "github_actions_secret" "oauth_user_id" {
  repository      = var.github_repository_name
  secret_name     = upper(replace("${local.env}_oauth_user_id", "-", "_"))
  plaintext_value = gloot_oauth_client.client.user_id
}

resource "github_actions_secret" "oauth_user_password" {
  repository      = var.github_repository_name
  secret_name     = upper(replace("${local.env}_oauth_user_password", "-", "_"))
  plaintext_value = gloot_oauth_client.client.secrets[0]
}
