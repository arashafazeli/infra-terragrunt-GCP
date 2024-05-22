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

resource "tls_private_key" "key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "kubernetes_secret" "secrets" {
  for_each = toset(var.namespace)
  metadata {
    name      = var.secret_name
    namespace = each.key
    labels    = local.labels
  }
  type = "Opaque"
  data = {
    "rsa.key"     = tls_private_key.key.private_key_pem
    "rsa.key_pub" = tls_private_key.key.public_key_pem
  }
}

