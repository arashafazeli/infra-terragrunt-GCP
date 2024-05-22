resource "google_logging_metric" "logging_metric" {
  name   = var.name
  filter = var.filter

  metric_descriptor {
    metric_kind = var.metric_kind
    value_type  = var.value_type
  }
}
