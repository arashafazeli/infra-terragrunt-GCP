

resource "google_monitoring_alert_policy" "alert_policy" {
  display_name          = var.name
  combiner              = var.combiner
  enabled               = var.enabled
  notification_channels = var.notification_channels

  dynamic "documentation" {
    for_each = var.documentation != null ? [var.documentation] : []
    content {
      content = documentation.value.content
    }
  }

  dynamic "conditions" {
    for_each = var.conditions
    content {
      display_name = conditions.value.display_name
      condition_threshold {
        filter          = conditions.value.condition_threshold.filter
        duration        = conditions.value.condition_threshold.duration
        comparison      = conditions.value.condition_threshold.comparison
        threshold_value = conditions.value.condition_threshold.threshold_value
        dynamic "trigger" {
          for_each = conditions.value.condition_threshold.trigger != null ? [conditions.value.condition_threshold.trigger] : []
          content {
            count = trigger.value.count
          }
        }
        aggregations {
          alignment_period     = conditions.value.condition_threshold.aggregations.alignment_period
          per_series_aligner   = conditions.value.condition_threshold.aggregations.per_series_aligner
          cross_series_reducer = conditions.value.condition_threshold.aggregations.cross_series_reducer
          group_by_fields      = conditions.value.condition_threshold.aggregations.group_by_fields
        }
      }
    }
  }
  user_labels = var.user_labels

  lifecycle {
    ignore_changes = [
      enabled # Ignore if someone turns the policy off in the GCP console
    ]
  }
  depends_on = [
    google_logging_metric.logging_metric,
  ]
}

resource "google_logging_metric" "logging_metric" {
  count = var.metric_name != null ? 1 : 0

  name   = var.metric_name
  filter = var.metric_filter

  metric_descriptor {
    metric_kind = "DELTA"
    value_type  = "INT64"
  }
}
