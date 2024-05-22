resource "kubernetes_config_map" "cluster-info" {
  metadata {
    name      = "cluster-info"
    namespace = var.namespace
    labels    = var.labels
  }
  data = {
    "values.yaml" = <<-EOT
    google:
      project: "${var.project_id}"
      region: "${var.region}"
      clusterName: "${var.cluster_name}"
    dns:
      domain: "${var.dns_zone}"
    labels:
      env: "${var.labels.env}"
    EOT
  }
}