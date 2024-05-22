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
  config_path = "${get_parent_terragrunt_dir()}/tech/prod/gnog/monitoring/backup-stackdriver-opsgenie-notification-channel"
  mock_outputs = {
    name = "invalid"
  }
  mock_outputs_allowed_terraform_commands = ["plan", "destroy"]
}

dependency "metrics" {
  config_path                             = "${get_parent_terragrunt_dir()}/tech/prod/gnog/monitoring/db-export-alert-policy/metrics"
  mock_outputs_allowed_terraform_commands = ["plan", "destroy"]
  skip_outputs                            = true
}

inputs = {
  name                  = "gnog prod db export monitoring-Cloud Function - Executions"
  combiner              = "OR"
  notification_channels = ["${dependency.notification-channel.outputs.name}"]
  conditions = [{
    display_name = "db export monitoring-Cloud Function metrics"
    condition_threshold = {
      comparison      = "COMPARISON_GT"
      duration        = "300s"
      filter          = "resource.type = \"cloud_function\" AND resource.labels.function_name = \"export-cloud-sql-db\" AND metric.type = \"logging.googleapis.com/user/db-backup\""
      threshold_value = "10"
      trigger = {
        count = "1"
      }
      aggregations = {
        alignment_period : "300s"
        per_series_aligner : "ALIGN_MEAN"
      }
    }
    },
    {
      display_name = "Cloud Function - Execution times"
      condition_threshold = {
        comparison      = "COMPARISON_GT"
        duration        = "300s"
        filter          = "resource.type = \"cloud_function\" AND resource.labels.function_name = \"export-cloud-sql-db\" AND metric.type = \"cloudfunctions.googleapis.com/function/execution_times\""
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
