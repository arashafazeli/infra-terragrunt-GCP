module "metrics" {
  for_each    = var.metrics
  source      = "./metric"
  name        = each.key
  filter      = each.value.filter
  metric_kind = each.value.metric_kind
  value_type  = each.value.value_type
}
