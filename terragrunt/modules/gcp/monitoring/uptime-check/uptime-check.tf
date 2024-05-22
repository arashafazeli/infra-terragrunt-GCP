data "google_client_config" "current" {}

resource "google_monitoring_uptime_check_config" "https" {
  for_each     = toset(var.paths)
  display_name = "${var.host}${each.key}"
  timeout      = var.timeout

  http_check {
    path         = each.key
    port         = "443"
    use_ssl      = true
    validate_ssl = true
  }

  monitored_resource {
    type = "uptime_url"
    labels = {
      project_id = data.google_client_config.current.project
      host       = var.host
    }
  }
}

module "uptime-alert-policy" {
  for_each              = google_monitoring_uptime_check_config.https
  source                = "./alert-policy"
  name                  = "Uptime alert policy for ${google_monitoring_uptime_check_config.https[each.key].uptime_check_id}"
  notification_channels = var.notification_channels
  combiner              = "OR"
  conditions = [
    {
      display_name = "Uptime alert policy condition for ${google_monitoring_uptime_check_config.https[each.key].uptime_check_id}"
      condition_threshold = {
        filter          = "metric.type=\"monitoring.googleapis.com/uptime_check/check_passed\" resource.type=\"uptime_url\" metric.label.\"check_id\"=\"${google_monitoring_uptime_check_config.https[each.key].uptime_check_id}\""
        duration        = "60s"
        comparison      = "COMPARISON_GT"
        threshold_value = "2.0"
        aggregations = {
          alignment_period     = "1200s"
          per_series_aligner   = "ALIGN_NEXT_OLDER"
          cross_series_reducer = "REDUCE_COUNT_FALSE"
          group_by_fields      = ["resource.*"]
        }
      }
    }
  ]
}
