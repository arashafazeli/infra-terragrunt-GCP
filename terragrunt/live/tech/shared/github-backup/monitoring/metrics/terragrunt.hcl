include {
  path = find_in_parent_folders()
}

terraform {
  source = "${get_parent_terragrunt_dir()}/..//modules/gcp/monitoring/metric-multiple"
}

dependency "project" {
  config_path = "${get_parent_terragrunt_dir()}/tech/shared/github-backup/_project"
  mock_outputs = {
    project_id = "invalid"
  }
  mock_outputs_allowed_terraform_commands = ["plan", "destroy"]
}

inputs = {
  metrics = {
    "github-backup" = {
      filter      = "resource.type=\"cloud_function\" resource.labels.function_name=\"github_backup\" resource.labels.region=\"europe-west1\" textPayload:failed OR Failed OR crash OR error OR fail"
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
