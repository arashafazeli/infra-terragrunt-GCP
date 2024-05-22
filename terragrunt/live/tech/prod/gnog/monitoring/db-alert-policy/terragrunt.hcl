include {
  path = find_in_parent_folders()
}

terraform {
  source = "${get_parent_terragrunt_dir()}/..//modules/gcp/monitoring/alert-policy"
}

dependency "project" {
  config_path = "${get_parent_terragrunt_dir()}/tech/prod/gnog/_project"
  mock_outputs = {
    project_id = "invalid"
  }
  mock_outputs_allowed_terraform_commands = ["plan", "destroy"]
}

dependency "notification-channel" {
  config_path = "${get_parent_terragrunt_dir()}/tech/prod/gnog/monitoring/stackdriver-opsgenie-notification-channel"
  mock_outputs = {
    name = "invalid"
  }
  mock_outputs_allowed_terraform_commands = ["plan", "destroy"]
}

inputs = {
  name                  = "Gnog-prod Cloud SQL Alert Policies"
  combiner              = "OR"
  notification_channels = ["${dependency.notification-channel.outputs.name}"]
  conditions = [{
    display_name = "Gnog-prod Cloud SQL CPU > 80% for 5min"
    condition_threshold = {
      filter          = "metric.type=\"cloudsql.googleapis.com/database/cpu/utilization\" resource.type=\"cloudsql_database\" metadata.user_labels.\"kubernetes_label_env\"=\"prod\""
      duration        = "180s"
      comparison      = "COMPARISON_GT"
      threshold_value = "0.80"
      aggregations = {
        alignment_period   = "180s"
        per_series_aligner = "ALIGN_MEAN"
      }
    }
    },
    {
      display_name = "Gnog-prod Cloud SQL Memory > 80% for 5min"
      condition_threshold = {
        filter          = "metric.type=\"cloudsql.googleapis.com/database/memory/utilization\" resource.type=\"cloudsql_database\" metadata.user_labels.\"kubernetes_label_env\"=\"prod\""
        duration        = "180s"
        comparison      = "COMPARISON_GT"
        threshold_value = "0.80"
        aggregations = {
          alignment_period   = "180s"
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
      project = "${dependency.project.outputs.project_id}"
      region  = "europe-west1"
    }
    EOF
}
