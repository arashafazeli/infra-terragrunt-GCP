include {
  path = find_in_parent_folders()
}

terraform {
  source = "${get_parent_terragrunt_dir()}/..//modules/gcp/monitoring/alert-policy"
}

dependency "project" {
  config_path = "${get_parent_terragrunt_dir()}/tech/dev/gnog/_project"
  mock_outputs = {
    project_id = "invalid"
  }
  mock_outputs_allowed_terraform_commands = ["plan", "destroy"]
}

dependency "notification-channel" {
  config_path = "${get_parent_terragrunt_dir()}/tech/dev/gnog/monitoring/stackdriver-opsgenie-notification-channel"
  mock_outputs = {
    name = "invalid"
  }
  mock_outputs_allowed_terraform_commands = ["plan", "destroy"]
}

inputs = {
  name                  = "Gnog-dev Log entry alert"
  combiner              = "OR"
  notification_channels = ["${dependency.notification-channel.outputs.name}"]
  conditions = [{
    display_name = "Gnog-dev Log entry > 100 kB/s"
    condition_threshold = {
      filter          = "metric.type=\"logging.googleapis.com/billing/log_bucket_bytes_ingested\" resource.type=\"global\"",
      duration        = "0s"
      comparison      = "COMPARISON_GT"
      threshold_value = "3000000"
      aggregations = {
        alignment_period   = "300s"
        per_series_aligner = "ALIGN_RATE"
      }
    }
    },
    {
      display_name = "Gnog-dev Log entry per service"
      condition_threshold = {
        filter          = "metric.type=\"logging.googleapis.com/log_entry_count\" resource.type=\"k8s_container\"",
        duration        = "0s"
        comparison      = "COMPARISON_GT"
        threshold_value = "25000"
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
      project = "${dependency.project.outputs.project_id}"
      region  = "europe-west1"
    }
    EOF
}
