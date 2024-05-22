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

dependency "metrics" {
  config_path                             = "${get_parent_terragrunt_dir()}/tech/dev/gnog/monitoring/bi-alert-policy/metrics"
  mock_outputs_allowed_terraform_commands = ["plan", "destroy"]
  skip_outputs                            = true
}

inputs = {
  name                  = "Analytics Service - Consumption of Kafka topics 2 [DEV]"
  combiner              = "OR"
  notification_channels = ["projects/gnog-dev-af5b/notificationChannels/1362685688069915560"]
  conditions = [{
    display_name = "Stopped Consuming Versus Events"
    condition_threshold = {
      filter          = "metric.type=\"logging.googleapis.com/user/bi-pipeline-topic-dev-error-versus\" resource.type=\"k8s_container\""
      duration        = "0s"
      comparison      = "COMPARISON_GT"
      threshold_value = "100"
      trigger = {
        count = "1"
      }
      aggregations = {
        alignment_period : "60s",
        cross_series_reducer : "REDUCE_SUM",
        per_series_aligner : "ALIGN_RATE"
      }
    }
    },
    {
      display_name = "Stopped Consuming Maintenance Events"
      condition_threshold = {
        filter          = "metric.type=\"logging.googleapis.com/user/bi-pipeline-topic-dev-error-gameStatus\" resource.type=\"k8s_container\""
        duration        = "0s"
        comparison      = "COMPARISON_GT"
        threshold_value = "100"
        trigger = {
          count = "1"
        }
        aggregations = {
          alignment_period : "60s",
          cross_series_reducer : "REDUCE_SUM",
          per_series_aligner : "ALIGN_RATE"
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
