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
  name                  = "Analytics Service - Consumption of Kafka topics 1 [DEV]"
  combiner              = "OR"
  notification_channels = ["projects/gnog-dev-af5b/notificationChannels/1362685688069915560"]
  conditions = [{
    display_name = "Stopped Consuming Game(Feature) Events"
    condition_threshold = {
      filter          = "metric.type=\"logging.googleapis.com/user/bi-pipeline-topic-dev-error-featureTopic\" resource.type=\"k8s_container\""
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
        filter          = "metric.type=\"logging.googleapis.com/user/bi-pipeline-topic-dev-error-raw-events\" resource.type=\"k8s_container\""
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
        filter          = "metric.type=\"logging.googleapis.com/user/bi-pipeline-topic-dev-error-stats\" resource.type=\"k8s_container\""
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
        filter          = "metric.type=\"logging.googleapis.com/user/bi-pipeline-topic-dev-error-src\" resource.type=\"k8s_container\""
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
        filter          = "metric.type=\"logging.googleapis.com/user/bi-pipeline-topic-dev-error-tbc\" resource.type=\"k8s_container\""
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
        filter          = "metric.type=\"logging.googleapis.com/user/bi-pipeline-topic-dev-error-unknown-topic\" resource.type=\"k8s_container\""
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
