locals {
  config = merge(var.default_release_config, var.release_config)
}

resource "helm_release" "release" {
  name        = local.config.name
  repository  = local.config.repository
  namespace   = local.config.namespace
  chart       = local.config.chart
  version     = local.config.version
  atomic      = local.config.atomic
  max_history = local.config.max_history

  values = local.config.value_files

  dynamic "set" {
    for_each = var.sets

    content {
      name  = set.key
      value = set.value
    }
  }
}