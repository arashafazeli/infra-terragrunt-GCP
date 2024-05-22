locals {
  config = merge(var.default_namespace_config, var.namespace_config)
  # Some logic to handle env variable for both old dev, prod and new tech-folder
  env = length(regexall("/live/tech/(.*?)/", abspath(path.root))) > 0 ? regex("/live/tech/(.*?)/", abspath(path.root))[0] : regex("/live/(.*?)/", abspath(path.root))[0]
  labels = {
    kubernetes_cluster       = var.cluster_name
    kubernetes_namespace     = local.config.name
    kubernetes_label_env     = local.env
    kubernetes_label_product = var.product
    kubernetes_label_team    = var.team
  }
}

resource "kubernetes_namespace" "namespace" {
  metadata {
    name        = local.config.name
    annotations = local.config.annotations
    labels      = local.labels
  }
}