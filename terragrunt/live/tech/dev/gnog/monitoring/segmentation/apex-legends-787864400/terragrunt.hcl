include {
  path = find_in_parent_folders()
}

terraform {
  source = "${get_parent_terragrunt_dir()}/..//modules/gcp/monitoring/alert-policy-multiple"
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
  user_labels = {
    team    = "insights"
    product = "gnog"
    service = "segmentation"
  }

  alert_policies = {
    "Segmentation - Amplitude API Error, Apex Legends (787864400)" = {
      combiner              = "OR"
      notification_channels = ["${dependency.notification-channel.outputs.name}"]

      metric_name   = "segmentation-787864400-connection-error"
      metric_filter = "resource.type=\"k8s_container\"\r\nresource.labels.namespace_name=\"default\"\r\nresource.labels.container_name=\"single-round-challenge-service\"\r\nresource.labels.location=\"europe-west1\"\r\nresource.labels.cluster_name=\"gloot-cluster\"\r\nresource.labels.project_id=\"gnog-dev-af5b\"\r\nlabels.\"k8s-pod/spring-boot\"=\"true\"\r\n\"segmentation-787864400\"\r\n\"Error when making request to Ampltiude\"\r\n"

      documentation = {
        content = "Backend receiving errors when fetching data from Amplitude API"
      }
      conditions = [{
        display_name = "Connection error to amplitude API - segmentation-787864400"
        condition_threshold = {
          filter          = "metric.type=\"logging.googleapis.com/user/segmentation-787864400-connection-error\" resource.type=\"k8s_container\""
          duration        = "0s"
          comparison      = "COMPARISON_GT"
          threshold_value = "100"
          trigger = {
            count = "1"
          }
          aggregations = {
            alignment_period     = "43200s"
            cross_series_reducer = "REDUCE_COUNT"
            per_series_aligner   = "ALIGN_DELTA"
          }
        }
      }]
    }
    "Segmentation - Empty Payload Error, Apex Legends (787864400)" = {
      combiner              = "OR"
      notification_channels = ["${dependency.notification-channel.outputs.name}"]

      metric_name   = "empty-response-at-endpoint-segmentation-787864400"
      metric_filter = "resource.type=\"k8s_container\"\r\nresource.labels.namespace_name=\"default\"\r\nresource.labels.container_name=\"single-round-challenge-service\"\r\nresource.labels.location=\"europe-west1\"\r\nresource.labels.cluster_name=\"gloot-cluster\"\r\nresource.labels.project_id=\"gnog-dev-af5b\"\r\nlabels.\"k8s-pod/spring-boot\"=\"true\"\r\n\"segmentation-787864400\"\r\n\"Response was empty from Amplitude API\"\r\n"

      documentation = {
        content = "No description."
      }
      conditions = [{
        display_name = "empty-response-at-endpoint-segmentation-787864400"
        condition_threshold = {
          filter          = "metric.type=\"logging.googleapis.com/user/empty-response-at-endpoint-segmentation-787864400\" resource.type=\"k8s_container\""
          duration        = "0s"
          comparison      = "COMPARISON_GT"
          threshold_value = "0"
          trigger = {
            count = "1"
          }
          aggregations = {
            alignment_period     = "3600s"
            per_series_aligner   = "ALIGN_DELTA"
            cross_series_reducer = "REDUCE_SUM"
          }
        }
      }]
    }
    "Segmentation - Malformed Payload Error, Apex Legends (787864400)" = {
      combiner              = "OR"
      notification_channels = ["${dependency.notification-channel.outputs.name}"]

      metric_name   = "segmentation-787864400-malformed-error"
      metric_filter = "resource.type=\"k8s_container\"\r\nresource.labels.namespace_name=\"default\"\r\nresource.labels.container_name=\"single-round-challenge-service\"\r\nresource.labels.location=\"europe-west1\"\r\nresource.labels.cluster_name=\"gloot-cluster\"\r\nresource.labels.project_id=\"gnog-dev-af5b\"\r\nlabels.\"k8s-pod/spring-boot\"=\"true\"\r\n\"segmentation-787864400\"\r\n\"malformed\"\r\n"

      documentation = {
        content = "No description."
      }
      conditions = [{
        display_name = "segmentation-787864400-malformed-error"
        condition_threshold = {
          filter          = "metric.type=\"logging.googleapis.com/user/segmentation-787864400-malformed-error\" resource.type=\"k8s_container\""
          duration        = "0s"
          comparison      = "COMPARISON_GT"
          threshold_value = "0"
          trigger = {
            count = "1"
          }
          aggregations = {
            alignment_period     = "1800s"
            cross_series_reducer = "REDUCE_SUM"
            per_series_aligner   = "ALIGN_DELTA"
          }
        }
      }]
    }
    "Segmentation - No Challenges Fetched, Apex Legends (787864400)" = {
      combiner              = "OR"
      notification_channels = ["${dependency.notification-channel.outputs.name}"]

      metric_name   = "unable-to-fetch-challenges-for-apex"
      metric_filter = "resource.type=\"k8s_container\"\r\nresource.labels.namespace_name=\"default\"\r\nresource.labels.container_name=\"single-round-challenge-service\"\r\nresource.labels.location=\"europe-west1\"\r\nresource.labels.cluster_name=\"gloot-cluster\"\r\nresource.labels.project_id=\"gnog-dev-af5b\"\r\nlabels.\"k8s-pod/spring-boot\"=\"true\"\r\n\"787864400\"\r\n\"No challenges found\"\r\n"

      documentation = {
        content = "No description."
      }
      conditions = [{
        display_name = "Unable to fetch/no challenges for segment - 787864400"
        condition_threshold = {
          filter          = "metric.type=\"logging.googleapis.com/user/unable-to-fetch-challenges-for-apex\" resource.type=\"k8s_container\""
          duration        = "0s"
          comparison      = "COMPARISON_GT"
          threshold_value = "0"
          trigger = {
            count = "1"
          }
          aggregations = {
            alignment_period     = "1800s"
            per_series_aligner   = "ALIGN_DELTA"
            cross_series_reducer = "REDUCE_SUM"
          }
        }
      }]
    }
  }
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
