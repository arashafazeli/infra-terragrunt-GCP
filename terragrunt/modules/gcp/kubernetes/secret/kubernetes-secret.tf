locals {
  # Some logic to handle env variable for both old dev, prod and new tech-folder
  env = length(regexall("/live/tech/(.*?)/", abspath(path.root))) > 0 ? regex("/live/tech/(.*?)/", abspath(path.root))[0] : regex("/live/(.*?)/", abspath(path.root))[0]
  labels = {
    app     = var.service_name
    env     = local.env
    product = var.product
    team    = var.team
  }
}

resource "kubernetes_secret" "secrets" {
  metadata {
    name      = var.name
    namespace = var.namespace
    labels    = local.labels
  }
  type = var.type
  data = var.data
}
