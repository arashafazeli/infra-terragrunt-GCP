include {
  path = find_in_parent_folders()
}

terraform {
  source = "${get_parent_terragrunt_dir()}/..//modules/gcp/monitoring/metric-multiple"
}

dependency "project" {
  config_path = "${get_parent_terragrunt_dir()}/tech/prod//gnog/_project"
  mock_outputs = {
    project_id = "invalid"
  }
  mock_outputs_allowed_terraform_commands = ["plan", "destroy"]
}

inputs = {
  metrics = {
    "db-backup" = {
      filter      = "resource.type=\"cloud_function\" resource.labels.function_name=\"export-cloud-sql-db\" resource.labels.region=\"europe-west1\" textPayload:failed OR crash OR error OR fail"
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
