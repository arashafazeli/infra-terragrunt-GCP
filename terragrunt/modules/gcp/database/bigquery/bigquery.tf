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
}

resource "google_bigquery_dataset" "dataset" {
  dataset_id    = var.dataset_id
  friendly_name = var.dataset_name
  labels        = local.labels
}


resource "google_bigquery_table" "default" {
  dataset_id = google_bigquery_dataset.dataset.dataset_id
  for_each   = var.tables
  table_id   = each.key
  schema     = each.value
  labels     = local.labels
}

module "kubernetes-secret" {
  source = "./kubernetes-secret"
  name   = "${var.service_name}-big-query-secret"
  data = {
    datasetId = google_bigquery_dataset.dataset.dataset_id
  }
  namespace    = var.cluster_namespace
  service_name = var.service_name
  product      = var.product
  team         = var.team
}

module "service_account" {
  source = "./google-service-account"
  name   = var.service_name
  roles  = ["roles/bigquery.dataEditor", "roles/bigquery.jobUser", "roles/cloudprofiler.agent"]
  labels = local.labels_k8s
}
