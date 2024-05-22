locals {
  # Some logic to handle env variable for both old dev, prod and new tech-folder
  env = length(regexall("/live/tech/(.*?)/", abspath(path.root))) > 0 ? regex("/live/tech/(.*?)/", abspath(path.root))[0] : regex("/live/(.*?)/", abspath(path.root))[0]
  labels = {
    kubernetes_cluster       = var.cluster_name
    kubernetes_namespace     = var.cluster_namespace
    kubernetes_deployment    = var.service_name
    kubernetes_label_app     = var.service_name
    kubernetes_label_env     = local.env
    kubernetes_label_product = var.product
    kubernetes_label_team    = var.team
  }
  labels_k8s = {
    app     = local.labels.kubernetes_label_app
    env     = local.labels.kubernetes_label_env
    product = local.labels.kubernetes_label_product
    team    = local.labels.kubernetes_label_team
  }
  # If a db name is specified, create the DB.
  create_db = var.db_name != "" ? 1 : 0

  # If G-Loot roles are specified, create a G-Loot service account.
  create_gloot_sa = length(var.gloot_roles) != 0 ? 1 : 0
}

module "service_account" {
  source    = "./google-service-account"
  namespace = var.cluster_namespace
  name      = var.service_name
  labels    = local.labels_k8s
  roles     = var.google_roles
}

module "gloot-service-account" {
  count          = local.create_gloot_sa
  source         = "./gloot-service-account"
  name           = var.service_name
  roles          = var.gloot_roles
  refresh_tokens = var.gloot_refresh_tokens
}

module "kubernetes-secret-gloot-token" {
  count        = local.create_gloot_sa
  source       = "./secret"
  name         = "${var.service_name}-gloot-token-secret"
  data         = module.gloot-service-account[0].refresh_token
  namespace    = var.cluster_namespace
  service_name = var.service_name
  product      = var.product
  team         = var.team
}

module "postgres-db" {
  count                               = local.create_db
  source                              = "./sql"
  network                             = var.network
  name_prefix                         = "${var.service_name}-db"
  db_name                             = var.db_name
  postgres_version                    = var.postgres_version
  deletion_protection                 = var.deletion_protection
  machine_type                        = var.db_instance_type
  user_name                           = var.db_user_name
  database_flags                      = var.database_flags
  db_enable_failover_replica          = var.db_enable_failover_replica
  db_insights_enabled                 = var.db_insights_enabled
  db_insights_record_application_tags = var.db_insights_record_application_tags
  db_insights_record_client_address   = var.db_insights_record_client_address
  activation_policy                   = var.activation_policy
  labels                              = local.labels
}

module "kubernetes-secret" {
  count  = local.create_db
  source = "./secret"
  name   = "${var.service_name}-db-secret"
  data = {
    username        = var.db_user_name
    password        = module.postgres-db[0].password
    masterHostname  = module.postgres-db[0].master_proxy_connection
    defaultDatabase = var.db_name
  }
  namespace    = var.cluster_namespace
  service_name = var.service_name
  product      = var.product
  team         = var.team
}
