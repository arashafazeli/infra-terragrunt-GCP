locals {
  # Some logic to handle env variable for both old dev, prod and new tech-folder
  env = length(regexall("/live/tech/(.*?)/", abspath(path.root))) > 0 ? regex("/live/tech/(.*?)/", abspath(path.root))[0] : regex("/live/(.*?)/", abspath(path.root))[0]
  labels = {
    kubernetes_label_env  = local.env
    kubernetes_label_team = var.team
  }
}

resource "google_pubsub_topic" "pubsub_topic" {
  name   = var.name
  labels = local.labels
}