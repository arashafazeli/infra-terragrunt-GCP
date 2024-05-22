resource "random_id" "name" {
  byte_length = 2
}

locals {
  account_name = format("%s-%s", var.name, random_id.name.hex)
}

resource "random_password" "password" {
  length           = 16
  special          = true
  override_special = "_%@"
}

resource "gloot_service_account" "service_account" {
  name = local.account_name
}

resource "gloot_role" "role" {
  for_each = var.roles
  user_id  = gloot_service_account.service_account.id
  role     = each.key
}

resource "gloot_refresh_token" "token" {
  for_each = var.refresh_tokens
  user_id  = gloot_service_account.service_account.id
  roles    = each.value
}
