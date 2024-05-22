resource "google_cloud_scheduler_job" "pub_sub" {
  count       = var.topic_name != "" ? 1 : 0
  name        = var.name
  description = var.description
  schedule    = var.schedule
  time_zone   = "Europe/Stockholm"
  pubsub_target {
    topic_name = var.topic_name
    data       = base64encode(var.message)
  }
}

resource "google_cloud_scheduler_job" "http" {
  count       = var.http_uri != "" ? 1 : 0
  name        = var.name
  description = var.description
  schedule    = var.schedule
  time_zone   = "Europe/Stockholm"
  http_target {
    http_method = var.http_method
    uri         = var.http_uri
    body        = var.message != "" ? base64encode(var.message) : null
  }
}
