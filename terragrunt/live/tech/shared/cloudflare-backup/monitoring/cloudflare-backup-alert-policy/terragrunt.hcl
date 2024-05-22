include {
  path = find_in_parent_folders()
}

terraform {
  source = "${get_parent_terragrunt_dir()}/..//modules/gcp/monitoring/alert-policy"
}

dependency "project" {
  config_path = "${get_parent_terragrunt_dir()}/tech/shared/cloudflare-backup/_project"
  mock_outputs = {
    project_id = "invalid"
  }
  mock_outputs_allowed_terraform_commands = ["plan", "destroy"]
}

dependency "notification-channel" {
  config_path = "${get_parent_terragrunt_dir()}/tech/shared/cloudflare-backup/monitoring/stackdriver-opsgenie-notification-channel"
  mock_outputs = {
    name = "invalid"
  }
  mock_outputs_allowed_terraform_commands = ["plan", "destroy"]
}

dependency "metrics" {
  config_path                             = "${get_parent_terragrunt_dir()}/tech/shared/cloudflare-backup/monitoring/metrics"
  mock_outputs_allowed_terraform_commands = ["plan", "destroy"]
  skip_outputs                            = true
}

inputs = {
  name                  = "Cloudflare Backup monitoring Alert Policies"
  combiner              = "OR"
  notification_channels = ["${dependency.notification-channel.outputs.name}"]
  conditions = [{
    display_name = "cloudflare export monitoring-Cloud Function - Executions"
    condition_threshold = {
      comparison      = "COMPARISON_GT"
      duration        = "300s"
      filter          = "resource.type = \"cloud_function\" AND resource.labels.function_name = \"cloudflare_backup\" AND metric.type = \"logging.googleapis.com/user/cloudflare-backup\""
      threshold_value = "0"
      trigger = {
        count = "1"
      }
      aggregations = {
        alignment_period : "60s"
        per_series_aligner : "ALIGN_MEAN"
      }
    }
    },
    {
      display_name = "Cloud Function - Execution times"
      condition_threshold = {
        comparison      = "COMPARISON_GT"
        duration        = "300s"
        filter          = "resource.type = \"cloud_function\" AND resource.labels.function_name = \"cloudflare_backup\" AND metric.type = \"cloudfunctions.googleapis.com/function/execution_times\""
        threshold_value = 180000000000
        trigger = {
          count = "1"
        }
        aggregations = {
          alignment_period : "300s"
          per_series_aligner : "ALIGN_PERCENTILE_99"
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
