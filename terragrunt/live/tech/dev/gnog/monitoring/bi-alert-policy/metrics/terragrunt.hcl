include {
  path = find_in_parent_folders()
}

terraform {
  source = "${get_parent_terragrunt_dir()}/..//modules/gcp/monitoring/metric-multiple"
}

dependency "project" {
  config_path = "${get_parent_terragrunt_dir()}/tech/dev/gnog/_project"
  mock_outputs = {
    project_id = "invalid"
  }
  mock_outputs_allowed_terraform_commands = ["plan", "destroy"]
}

inputs = {
  metrics = {
    "bi-pipeline-dev-currency-conversion-fail" = {
      filter      = "resource.labels.project_id=\"gnog-dev-af5b\" resource.labels.cluster_name=\"gloot-cluster\" resource.type=\"k8s_container\" resource.labels.location=\"europe-west1\" resource.labels.namespace_name=\"default\" resource.labels.pod_name:\"bi-pipeline-\" textPayload:\"Failed to convert currency to euro\""
      metric_kind = "DELTA"
      value_type  = "INT64"
    },
    "bi-pipeline-dev-unknown-properties" = {
      filter      = "resource.type=\"k8s_container\" resource.labels.project_id=\"gnog-dev-af5b\" resource.labels.location=\"europe-west1\" resource.labels.cluster_name=\"gloot-cluster\" resource.labels.namespace_name=\"default\" resource.labels.pod_name:\"bi-pipeline-\" textPayload:\"Properties missed\" NOT textPayload:\"'reason'\" NOT textPayload:\"'scoreExpression'\" NOT textPayload:\"'labels'\" NOT textPayload:\"'explicit'\" NOT textPayload:\"'participantsEarned'\""
      metric_kind = "DELTA"
      value_type  = "INT64"
    },
    "bi-pipeline-topic-dev-error-featureTopic" = {
      filter      = "resource.type=\"k8s_container\" resource.labels.project_id=\"gnog-dev-af5b\" resource.labels.location=\"europe-west1\" resource.labels.cluster_name=\"gloot-cluster\" resource.labels.namespace_name=\"default\" resource.labels.pod_name:\"bi-pipeline-\" textPayload:\"TOPIC ERROR: featureTopic\""
      metric_kind = "DELTA"
      value_type  = "INT64"
    },
    "bi-pipeline-topic-dev-error-gameStatus" = {
      filter      = "resource.labels.project_id=\"gnog-dev-af5b\" resource.labels.cluster_name=\"gloot-cluster\" resource.type=\"k8s_container\" resource.labels.location=\"europe-west1\" resource.labels.namespace_name=\"default\" resource.labels.pod_name:\"bi-pipeline-\" textPayload:\"TOPIC ERROR: gameStatus\""
      metric_kind = "DELTA"
      value_type  = "INT64"
    },
    "bi-pipeline-topic-dev-error-raw-events" = {
      filter      = "resource.type=\"k8s_container\" resource.labels.project_id=\"gnog-dev-af5b\" resource.labels.location=\"europe-west1\" resource.labels.cluster_name=\"gloot-cluster\" resource.labels.namespace_name=\"default\" resource.labels.pod_name:\"bi-pipeline-\" textPayload:\"TOPIC ERROR: rawPublicGameEvents\""
      metric_kind = "DELTA"
      value_type  = "INT64"
    },
    "bi-pipeline-topic-dev-error-src" = {
      filter      = "resource.type=\"k8s_container\" resource.labels.project_id=\"gnog-dev-af5b\" resource.labels.location=\"europe-west1\" resource.labels.cluster_name=\"gloot-cluster\" resource.labels.namespace_name=\"default\" resource.labels.pod_name:\"bi-pipeline-\" textPayload:\"TOPIC ERROR: single-round-challenge\""
      metric_kind = "DELTA"
      value_type  = "INT64"
    },
    "bi-pipeline-topic-dev-error-stats" = {
      filter      = "resource.type=\"k8s_container\" resource.labels.project_id=\"gnog-dev-af5b\" resource.labels.location=\"europe-west1\" resource.labels.cluster_name=\"gloot-cluster\" resource.labels.namespace_name=\"default\" resource.labels.pod_name:\"bi-pipeline-\" textPayload:\"TOPIC ERROR: timebased-challenge\""
      metric_kind = "DELTA"
      value_type  = "INT64"
    },
    "bi-pipeline-topic-dev-error-tbc" = {
      filter      = "resource.type=\"k8s_container\" resource.labels.project_id=\"gnog-dev-af5b\" resource.labels.location=\"europe-west1\" resource.labels.cluster_name=\"gloot-cluster\" resource.labels.namespace_name=\"default\" resource.labels.pod_name:\"bi-pipeline-\" textPayload:\"TOPIC ERROR: rawPublicGameEvents\""
      metric_kind = "DELTA"
      value_type  = "INT64"
    },
    "bi-pipeline-topic-dev-error-unknown-topic" = {
      filter      = "resource.type=\"k8s_container\" resource.labels.project_id=\"gnog-dev-af5b\" resource.labels.location=\"europe-west1\" resource.labels.cluster_name=\"gloot-cluster\" resource.labels.namespace_name=\"default\" resource.labels.pod_name:\"bi-pipeline-\" NOT textPayload:\"TOPIC ERROR: rawPublicGameEvents\" NOT textPayload:\"TOPIC ERROR: single-round-challenge\" NOT textPayload:\"TOPIC ERROR: timebased-challenge\" NOT textPayload:\"TOPIC ERROR: event.stats.updates\" NOT textPayload:\"TOPIC ERROR: featureTopic\" NOT textPayload:\"TOPIC ERROR: gameStatus\" NOT textPayload:\"TOPIC ERROR: versus-challenge.events\" textPayload:\"TOPIC ERROR: \""
      metric_kind = "DELTA"
      value_type  = "INT64"
    },
    "bi-pipeline-topic-dev-error-versus" = {
      filter      = "resource.labels.project_id=\"gnog-dev-af5b\" resource.labels.cluster_name=\"gloot-cluster\" resource.type=\"k8s_container\" resource.labels.location=\"europe-west1\" resource.labels.namespace_name=\"default\" resource.labels.pod_name:\"bi-pipeline-\" textPayload:\"TOPIC ERROR: versus-challenge.events\""
      metric_kind = "DELTA"
      value_type  = "INT64"
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