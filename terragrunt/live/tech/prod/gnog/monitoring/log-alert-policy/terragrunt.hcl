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
  name                  = "Gnog-prod Log entry alert"
  combiner              = "OR"
  notification_channels = ["${dependency.notification-channel.outputs.name}"]
  conditions = [{
    display_name = "Gnog-prod Log entry > 3mb/s"
    condition_threshold = {
      aggregations = {
        alignment_period   = "300s"
        per_series_aligner = "ALIGN_RATE"
      }
      comparison      = "COMPARISON_GT"
      duration        = "0s"
      filter          = "metric.type=\"logging.googleapis.com/billing/log_bucket_bytes_ingested\" resource.type=\"global\""
      threshold_value = 3000000
    }
    },
    {
      display_name = "Gnog-prod Log entry per service"
      condition_threshold = {
        filter          = "metric.type=\"logging.googleapis.com/log_entry_count\" resource.type=\"k8s_container\"",
        duration        = "0s"
        comparison      = "COMPARISON_GT"
        threshold_value = "25000"
        aggregations = {
          alignment_period     = "300s"
          per_series_aligner   = "ALIGN_MEAN"
          cross_series_reducer = "REDUCE_SUM"
          group_by_fields = [
            "resource.label.container_name"
          ]
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
