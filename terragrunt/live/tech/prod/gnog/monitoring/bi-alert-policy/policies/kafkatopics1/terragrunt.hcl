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

dependency "metrics" {
  config_path                             = "${get_parent_terragrunt_dir()}/tech/prod/gnog/monitoring/bi-alert-policy/metrics"
  mock_outputs_allowed_terraform_commands = ["plan", "destroy"]
  skip_outputs                            = true
}


inputs = {
  name                  = "Analytics Service - Consumption of Kafka topics 1"
  combiner              = "OR"
  notification_channels = ["projects/gnog-prod-05e6/notificationChannels/3644784551637693945"]
  conditions = [{
    display_name = "Stopped Consuming Game(Feature) Events"
    condition_threshold = {
      filter          = "metric.type=\"logging.googleapis.com/user/bi-pipeline-topic-error-featureTopic\" resource.type=\"k8s_container\""
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
      display_name = "Stopped Consuming Raw Game Events"
      condition_threshold = {
        filter          = "metric.type=\"logging.googleapis.com/user/bi-pipeline-topic-error-raw-events\" resource.type=\"k8s_container\""
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
      display_name = "Stopped Consuming Stats Events"
      condition_threshold = {
        filter          = "metric.type=\"logging.googleapis.com/user/bi-pipeline-topic-error-stats\" resource.type=\"k8s_container\""
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
      display_name = "Stopped Consuming Single-Round Events"
      condition_threshold = {
        filter          = "metric.type=\"logging.googleapis.com/user/bi-pipeline-topic-error-src\" resource.type=\"k8s_container\""
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
      display_name = "Stopped Consuming Time-Based Events"
      condition_threshold = {
        filter          = "metric.type=\"logging.googleapis.com/user/bi-pipeline-topic-error-tbc\" resource.type=\"k8s_container\""
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
      display_name = "Stopped Consuming Unknown Topic (Add alert to topic)"
      condition_threshold = {
        filter          = "metric.type=\"logging.googleapis.com/user/bi-pipeline-topic-error-unknown-topic\" resource.type=\"k8s_container\""
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
