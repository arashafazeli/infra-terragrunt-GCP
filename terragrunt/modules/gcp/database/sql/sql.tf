resource "random_id" "name" {
  byte_length = 2
}

locals {
  instance_name = format("%s-%s", var.name_prefix, random_id.name.hex)

  # Put DB in private network, if new environments.
  enable_public_internet_access = var.network == null
}

resource "random_password" "password" {
  length           = 16
  special          = true
  override_special = "_%@"
}

module "postgres" {
  source = "./cloud-sql"

  name    = local.instance_name
  db_name = var.db_name
  network = var.network

  engine              = var.postgres_version
  deletion_protection = var.deletion_protection
  deletion_policy     = var.deletion_policy
  machine_type        = var.machine_type

  master_user_password = random_password.password.result
  master_user_name     = var.user_name

  enable_public_internet_access = local.enable_public_internet_access

  activation_policy = var.activation_policy

  require_ssl = true

  database_flags = var.database_flags

  master_zone = var.zone

  db_enable_failover_replica = var.db_enable_failover_replica

  num_read_replicas  = 0
  read_replica_zones = []

  db_insights_enabled                 = var.db_insights_enabled
  db_insights_query_string_length     = var.db_insights_query_string_length
  db_insights_record_application_tags = var.db_insights_record_application_tags
  db_insights_record_client_address   = var.db_insights_record_client_address

  custom_labels = var.labels
}
