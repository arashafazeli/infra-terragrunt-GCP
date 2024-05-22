inputs = {
  project                 = dependency.project.outputs.project_name
  destination_endpoint_id = dependency.prometheus.outputs.id
  integration_type        = "prometheus"
  source_service_name     = dependency.kafka.outputs.name
}

include {
  path = find_in_parent_folders()
}

terraform {
  source = "${get_parent_terragrunt_dir()}/..//modules/aiven/service-integration/"
}

prevent_destroy = true

dependency "project" {
  config_path = "${get_parent_terragrunt_dir()}/tech/prod/aiven/project"
  mock_outputs = {
    project_name = "invalid"
  }
  mock_outputs_allowed_terraform_commands = ["plan", "destroy"]
}

dependency "prometheus" {
  config_path = "${get_parent_terragrunt_dir()}/tech/prod/aiven/prometheus"
  mock_outputs = {
    id = "invalid/invalid"
  }
  mock_outputs_allowed_terraform_commands = ["plan", "destroy"]
}

dependency "kafka" {
  config_path = "${get_parent_terragrunt_dir()}/tech/prod/aiven/kafka"
  mock_outputs = {
    name = "invalid"
  }
  mock_outputs_allowed_terraform_commands = ["plan", "destroy"]
}
