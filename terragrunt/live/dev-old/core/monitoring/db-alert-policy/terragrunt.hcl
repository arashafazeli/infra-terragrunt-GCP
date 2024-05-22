include {
  path = find_in_parent_folders()
}

terraform {
  source = "${get_parent_terragrunt_dir()}/..//modules/gcp/monitoring/alert-policy"
}

dependency "notification-channel" {
  config_path = "${get_parent_terragrunt_dir()}/dev-old/core/monitoring/stackdriver-opsgenie-notification-channel"
  mock_outputs = {
    name = "invalid"
  }
  mock_outputs_allowed_terraform_commands = ["plan", "destroy"]
}

inputs = {
  name                  = "Dev Old Cloud SQL Alert Policies"
  combiner              = "OR"
  notification_channels = ["${dependency.notification-channel.outputs.name}"]
  conditions = [{
    display_name = "Dev-old Cloud SQL CPU > 80% for 5min"
    condition_threshold = {
      filter          = "metric.type=\"cloudsql.googleapis.com/database/cpu/utilization\" resource.type=\"cloudsql_database\" metadata.user_labels.\"kubernetes_label_env\"=\"dev-old\""
      duration        = "300s"
      comparison      = "COMPARISON_GT"
      threshold_value = "0.80"
      aggregations = {
        alignment_period   = "300s"
        per_series_aligner = "ALIGN_MEAN"
      }
    }
    },
    {
      display_name = "Dev-old Cloud SQL Memory > 80% for 5min"
      condition_threshold = {
        filter          = "metric.type=\"cloudsql.googleapis.com/database/memory/utilization\" resource.type=\"cloudsql_database\" metadata.user_labels.\"kubernetes_label_env\"=\"dev-old\""
        duration        = "300s"
        comparison      = "COMPARISON_GT"
        threshold_value = "0.80"
        aggregations = {
          alignment_period   = "300s"
          per_series_aligner = "ALIGN_MEAN"
        }
      }
  }]
}

generate "providers" {
  path      = "providers.tf"
  if_exists = "overwrite"
  contents  = <<-EOF
    provider "google" {
      project = "play-gll-gg"
      region  = "europe-west1"
    }
    EOF
}
