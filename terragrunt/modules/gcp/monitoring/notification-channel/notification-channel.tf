resource "google_monitoring_notification_channel" "notification_channel" {
  display_name = var.name
  type         = var.type
  enabled      = var.enabled
  labels       = var.labels
}
