include {
  path = find_in_parent_folders()
}

terraform {
  source = "${get_parent_terragrunt_dir()}/..//modules/gcp/monitoring/alert-policy-multiple"
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
  user_labels = {
    team    = "insights"
    product = "gnog"
    service = "segmentation"
  }

  alert_policies = {
    "Segmentation - Amplitude API Error, Valorant (1892449706) Assists" = {
      combiner              = "OR"
      notification_channels = ["${dependency.notification-channel.outputs.name}"]

      metric_name   = "segmentation-1892449706-assists-connection-error"
      metric_filter = "resource.type=\"k8s_container\"\r\nresource.labels.project_id=\"gnog-prod-05e6\"\r\nresource.labels.location=\"europe-west1\"\r\nresource.labels.cluster_name=\"gloot-cluster\"\r\nresource.labels.namespace_name=\"default\"\r\nlabels.k8s-pod/app=\"single-round-challenge-service\" severity>=DEFAULT\r\nlabels.\"k8s-pod/spring-boot\"=\"true\" \r\n\"segmentation-1892449706-kills\" \r\n\"No challenges found\""

      documentation = {
        content = "Backend receiving errors when fetching data from Amplitude API"
      }
      conditions = [{
        display_name = "Connection error to amplitude API - segmentation-1892449706-assists"
        condition_threshold = {
          filter          = "metric.type=\"logging.googleapis.com/user/segmentation-1892449706-assists-connection-error\" resource.type=\"k8s_container\""
          duration        = "0s"
          comparison      = "COMPARISON_GT"
          threshold_value = "100"
          trigger = {
            count = "1"
          }
          aggregations = {
            alignment_period     = "43200s"
            cross_series_reducer = "REDUCE_COUNT"
            per_series_aligner   = "ALIGN_RATE"
          }
        }
      }]
    }
    "Segmentation - Amplitude API Error, Valorant (1892449706) Headshots" = {
      combiner              = "OR"
      notification_channels = ["${dependency.notification-channel.outputs.name}"]

      metric_name   = "segmentation-1892449706-headshots-connection-error"
      metric_filter = "resource.type=\"k8s_container\"\r\nresource.labels.project_id=\"gnog-prod-05e6\"\r\nresource.labels.location=\"europe-west1\"\r\nresource.labels.cluster_name=\"gloot-cluster\"\r\nresource.labels.namespace_name=\"default\"\r\nlabels.k8s-pod/app=\"single-round-challenge-service\" severity>=DEFAULT\r\nlabels.\"k8s-pod/spring-boot\"=\"true\"\r\n\"segmentation-1892449706-headshots\"\r\n\"Error when making request to Ampltiude\""

      documentation = {
        content = "Backend receiving errors when fetching data from Amplitude API"
      }
      conditions = [{
        display_name = "Connection error to amplitude API - segmentation-1892449706-headshots"
        condition_threshold = {
          filter          = "metric.type=\"logging.googleapis.com/user/segmentation-1892449706-headshots-connection-error\" resource.type=\"k8s_container\""
          duration        = "0s"
          comparison      = "COMPARISON_GT"
          threshold_value = "100"
          trigger = {
            count = "1"
          }
          aggregations = {
            alignment_period     = "43200s"
            cross_series_reducer = "REDUCE_COUNT"
            per_series_aligner   = "ALIGN_RATE"
          }
        }
      }]
    }
    "Segmentation - Amplitude API Error, Valorant (1892449706) Kills" = {
      combiner              = "OR"
      notification_channels = ["${dependency.notification-channel.outputs.name}"]

      metric_name   = "segmentation-1892449706-kills-connection-error"
      metric_filter = "resource.type=\"k8s_container\"\r\nresource.labels.project_id=\"gnog-prod-05e6\"\r\nresource.labels.location=\"europe-west1\"\r\nresource.labels.cluster_name=\"gloot-cluster\"\r\nresource.labels.namespace_name=\"default\"\r\nlabels.k8s-pod/app=\"single-round-challenge-service\" severity>=DEFAULT\r\nlabels.\"k8s-pod/spring-boot\"=\"true\"\r\n\"segmentation-1892449706-kills\"\r\n\"Error when making request to Ampltiude\""

      documentation = {
        content = "Backend receiving errors when fetching data from Amplitude API"
      }
      conditions = [{
        display_name = "Connection error to amplitude API - segmentation-1892449706-kills"
        condition_threshold = {
          filter          = "metric.type=\"logging.googleapis.com/user/segmentation-1892449706-kills-connection-error\" resource.type=\"k8s_container\""
          duration        = "0s"
          comparison      = "COMPARISON_GT"
          threshold_value = "100"
          trigger = {
            count = "1"
          }
          aggregations = {
            alignment_period     = "43200s"
            cross_series_reducer = "REDUCE_COUNT"
            per_series_aligner   = "ALIGN_RATE"
          }
        }
      }]
    }
    "Segmentation - Empty Payload Error, Valorant (1892449706) Assists" = {
      combiner              = "OR"
      notification_channels = ["${dependency.notification-channel.outputs.name}"]

      metric_name   = "empty-response-at-endpoint-segmentation-1892449706-assists"
      metric_filter = "resource.type=\"k8s_container\"\r\nresource.labels.project_id=\"gnog-prod-05e6\"\r\nresource.labels.location=\"europe-west1\"\r\nresource.labels.cluster_name=\"gloot-cluster\"\r\nresource.labels.namespace_name=\"default\"\r\nlabels.k8s-pod/app=\"single-round-challenge-service\" severity>=DEFAULT\r\nlabels.\"k8s-pod/spring-boot\"=\"true\" \r\n\"segmentation-1892449706-assists\" \r\n\"Response was empty from Amplitude API\""

      documentation = {
        content = "No description."
      }
      conditions = [{
        display_name = "empty-response-at-endpoint-segmentation-1892449706-assists"
        condition_threshold = {
          filter          = "metric.type=\"logging.googleapis.com/user/empty-response-at-endpoint-segmentation-1892449706-assists\" resource.type=\"k8s_container\""
          duration        = "0s"
          comparison      = "COMPARISON_GT"
          threshold_value = "0"
          trigger = {
            count = "1"
          }
          aggregations = {
            alignment_period     = "3600s"
            cross_series_reducer = "REDUCE_COUNT"
            per_series_aligner   = "ALIGN_RATE"
          }
        }
      }]
    }
    "Segmentation - Empty Payload Error, Valorant (1892449706) Headshots" = {
      combiner              = "OR"
      notification_channels = ["${dependency.notification-channel.outputs.name}"]

      metric_name   = "empty-response-at-endpoint-segmentation-1892449706-headshots"
      metric_filter = "resource.type=\"k8s_container\"\r\nresource.labels.project_id=\"gnog-prod-05e6\"\r\nresource.labels.location=\"europe-west1\"\r\nresource.labels.cluster_name=\"gloot-cluster\"\r\nresource.labels.namespace_name=\"default\"\r\nlabels.k8s-pod/app=\"single-round-challenge-service\" severity>=DEFAULT\r\nlabels.\"k8s-pod/spring-boot\"=\"true\" \r\n\"segmentation-1892449706-headshots\" \r\n\"Response was empty from Amplitude API\""

      documentation = {
        content = "No description."
      }
      conditions = [{
        display_name = "empty-response-at-endpoint-segmentation-1892449706-headshots"
        condition_threshold = {
          filter          = "metric.type=\"logging.googleapis.com/user/empty-response-at-endpoint-segmentation-1892449706-headshots\" resource.type=\"k8s_container\""
          duration        = "0s"
          comparison      = "COMPARISON_GT"
          threshold_value = "0"
          trigger = {
            count = "1"
          }
          aggregations = {
            alignment_period     = "3600s"
            cross_series_reducer = "REDUCE_COUNT"
            per_series_aligner   = "ALIGN_RATE"
          }
        }
      }]
    }
    "Segmentation - Empty Payload Error, Valorant (1892449706) Kills" = {
      combiner              = "OR"
      notification_channels = ["${dependency.notification-channel.outputs.name}"]

      metric_name   = "empty-response-at-endpoint-segmentation-1892449706-kills"
      metric_filter = "resource.type=\"k8s_container\"\r\nresource.labels.project_id=\"gnog-prod-05e6\"\r\nresource.labels.location=\"europe-west1\"\r\nresource.labels.cluster_name=\"gloot-cluster\"\r\nresource.labels.namespace_name=\"default\"\r\nlabels.k8s-pod/app=\"single-round-challenge-service\" severity>=DEFAULT\r\nlabels.\"k8s-pod/spring-boot\"=\"true\" \r\n\"segmentation-1892449706-kills\" \r\n\"Response was empty from Amplitude API\""

      documentation = {
        content = "No description."
      }
      conditions = [{
        display_name = "empty-response-at-endpoint-segmentation-1892449706-kills"
        condition_threshold = {
          filter          = "metric.type=\"logging.googleapis.com/user/empty-response-at-endpoint-segmentation-1892449706-kills\" resource.type=\"k8s_container\""
          duration        = "0s"
          comparison      = "COMPARISON_GT"
          threshold_value = "0"
          trigger = {
            count = "1"
          }
          aggregations = {
            alignment_period     = "3600s"
            cross_series_reducer = "REDUCE_SUM"
            per_series_aligner   = "ALIGN_RATE"
          }
        }
      }]
    }
    "Segmentation - Malformed Payload Error, Valorant (1892449706) Assists" = {
      combiner              = "OR"
      notification_channels = ["${dependency.notification-channel.outputs.name}"]

      metric_name   = "segmentation-1892449706-assists-malformed-error"
      metric_filter = "resource.type=\"k8s_container\"\r\nresource.labels.project_id=\"gnog-prod-05e6\"\r\nresource.labels.location=\"europe-west1\"\r\nresource.labels.cluster_name=\"gloot-cluster\"\r\nresource.labels.namespace_name=\"default\"\r\nlabels.k8s-pod/app=\"single-round-challenge-service\" severity>=DEFAULT\r\nlabels.\"k8s-pod/spring-boot\"=\"true\"\r\n\"segmentation-1892449706-assists\"\r\n\"malformed\""

      documentation = {
        content = "No description."
      }
      conditions = [{
        display_name = "Segmentation-1892449706-assists-malformed-error"
        condition_threshold = {
          filter          = "metric.type=\"logging.googleapis.com/user/segmentation-1892449706-assists-malformed-error\" resource.type=\"k8s_container\""
          duration        = "0s"
          comparison      = "COMPARISON_GT"
          threshold_value = "0"
          trigger = {
            count = "1"
          }
          aggregations = {
            alignment_period     = "3600s"
            cross_series_reducer = "REDUCE_SUM"
            per_series_aligner   = "ALIGN_RATE"
          }
        }
      }]
    }
    "Segmentation - Malformed Payload Error, Valorant (1892449706) Headshots" = {
      combiner              = "OR"
      notification_channels = ["${dependency.notification-channel.outputs.name}"]

      metric_name   = "segmentation-1892449706-headshots-malformed-error"
      metric_filter = "resource.type=\"k8s_container\"\r\nresource.labels.project_id=\"gnog-prod-05e6\"\r\nresource.labels.location=\"europe-west1\"\r\nresource.labels.cluster_name=\"gloot-cluster\"\r\nresource.labels.namespace_name=\"default\"\r\nlabels.k8s-pod/app=\"single-round-challenge-service\" severity>=DEFAULT\r\nlabels.\"k8s-pod/spring-boot\"=\"true\"\r\n\"segmentation-1892449706-headshots\"\r\n\"malformed\""

      documentation = {
        content = "No description."
      }
      conditions = [{
        display_name = "Segmentation-1892449706-headshots-malformed-error"
        condition_threshold = {
          filter          = "metric.type=\"logging.googleapis.com/user/segmentation-1892449706-headshots-malformed-error\" resource.type=\"k8s_container\""
          duration        = "0s"
          comparison      = "COMPARISON_GT"
          threshold_value = "0"
          trigger = {
            count = "1"
          }
          aggregations = {
            alignment_period     = "3600s"
            cross_series_reducer = "REDUCE_COUNT"
            per_series_aligner   = "ALIGN_RATE"
          }
        }
      }]
    }
    "Segmentation - Malformed Payload Error, Valorant (1892449706) Kills" = {
      combiner              = "OR"
      notification_channels = ["${dependency.notification-channel.outputs.name}"]

      metric_name   = "segmentation-1892449706-kills-malformed-error"
      metric_filter = "resource.type=\"k8s_container\"\r\nresource.labels.project_id=\"gnog-prod-05e6\"\r\nresource.labels.location=\"europe-west1\"\r\nresource.labels.cluster_name=\"gloot-cluster\"\r\nresource.labels.namespace_name=\"default\"\r\nlabels.k8s-pod/app=\"single-round-challenge-service\" severity>=DEFAULT\r\nlabels.\"k8s-pod/spring-boot\"=\"true\"\r\n\"segmentation-1892449706-kills\"\r\n\"malformed\""

      documentation = {
        content = "No description."
      }
      conditions = [{
        display_name = "Segmentation-1892449706-kills-malformed-error"
        condition_threshold = {
          filter          = "metric.type=\"logging.googleapis.com/user/segmentation-1892449706-kills-malformed-error\" resource.type=\"k8s_container\""
          duration        = "0s"
          comparison      = "COMPARISON_GT"
          threshold_value = "0"
          trigger = {
            count = "1"
          }
          aggregations = {
            alignment_period     = "3600s"
            cross_series_reducer = "REDUCE_COUNT"
            per_series_aligner   = "ALIGN_RATE"
          }
        }
      }]
    }
    "Segmentation - No Challenges Fetched, Valorant (1892449706)" = {
      combiner              = "OR"
      notification_channels = ["${dependency.notification-channel.outputs.name}"]

      metric_name   = "unable-to-fetch-challenges-for-valorant"
      metric_filter = "resource.type=\"k8s_container\"\r\nresource.labels.project_id=\"gnog-prod-05e6\"\r\nresource.labels.location=\"europe-west1\"\r\nresource.labels.cluster_name=\"gloot-cluster\"\r\nresource.labels.namespace_name=\"default\"\r\nlabels.k8s-pod/app=\"single-round-challenge-service\"\r\n\"1892449706\"\r\n\"No challenges found\""

      documentation = {
        content = "No description."
      }
      conditions = [{
        display_name = "Unable to fetch/no challenges for segment - 1892449706"
        condition_threshold = {
          filter          = "metric.type=\"logging.googleapis.com/user/unable-to-fetch-challenges-for-valorant\" resource.type=\"k8s_container\""
          duration        = "0s"
          comparison      = "COMPARISON_GT"
          threshold_value = "0"
          trigger = {
            count = "1"
          }
          aggregations = {
            alignment_period     = "1800s"
            cross_series_reducer = "REDUCE_SUM"
            per_series_aligner   = "ALIGN_RATE"
          }
        }
      }]
    }
    "Segmentation - No Challenges Fetched For Segment, Valorant (1892449706) Headshots" = {
      combiner              = "OR"
      notification_channels = ["${dependency.notification-channel.outputs.name}"]

      metric_name   = "unable-to-fetch-challenges-for-segment-at-endpoint-segmentation-1892449706-headshots"
      metric_filter = "resource.type=\"k8s_container\"\r\nresource.labels.project_id=\"gnog-prod-05e6\"\r\nresource.labels.location=\"europe-west1\"\r\nresource.labels.cluster_name=\"gloot-cluster\"\r\nresource.labels.namespace_name=\"default\"\r\nlabels.k8s-pod/app=\"single-round-challenge-service\" severity>=DEFAULT\r\nlabels.\"k8s-pod/spring-boot\"=\"true\" \r\n\"segmentation-1892449706-headshots\" \r\n\"No challenges found\""

      documentation = {
        content = "No description."
      }
      conditions = [{
        display_name = "Unable to fetch/no challenges for segment - segmentation-1892449706-headshots"
        condition_threshold = {
          filter          = "metric.type=\"logging.googleapis.com/user/unable-to-fetch-challenges-for-segment-at-endpoint-segmentation-1892449706-headshots\" resource.type=\"k8s_container\""
          duration        = "0s"
          comparison      = "COMPARISON_GT"
          threshold_value = "0"
          trigger = {
            count = "1"
          }
          aggregations = {
            alignment_period     = "3600s"
            cross_series_reducer = "REDUCE_COUNT"
            per_series_aligner   = "ALIGN_RATE"
          }
        }
      }]
    }
    "Segmentation - No Challenges Fetched For Segment, Valorant (1892449706) Kills" = {
      combiner              = "OR"
      notification_channels = ["${dependency.notification-channel.outputs.name}"]

      metric_name   = "unable-to-fetch-challenges-for-segment-at-endpoint-segmentation-1892449706-kills"
      metric_filter = "resource.type=\"k8s_container\"\r\nresource.labels.project_id=\"gnog-prod-05e6\"\r\nresource.labels.location=\"europe-west1\"\r\nresource.labels.cluster_name=\"gloot-cluster\"\r\nresource.labels.namespace_name=\"default\"\r\nlabels.k8s-pod/app=\"single-round-challenge-service\" severity>=DEFAULT\r\nlabels.\"k8s-pod/spring-boot\"=\"true\" \r\n\"segmentation-1892449706-kills\" \r\n\"No challenges found\""

      documentation = {
        content = "No description."
      }
      conditions = [{
        display_name = "Unable to fetch/no challenges for segment - segmentation-1892449706-kills"
        condition_threshold = {
          filter          = "metric.type=\"logging.googleapis.com/user/unable-to-fetch-challenges-for-segment-at-endpoint-segmentation-1892449706-kills\" resource.type=\"k8s_container\""
          duration        = "0s"
          comparison      = "COMPARISON_GT"
          threshold_value = "0"
          trigger = {
            count = "1"
          }
          aggregations = {
            alignment_period     = "3600s"
            cross_series_reducer = "REDUCE_COUNT"
            per_series_aligner   = "ALIGN_RATE"
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
