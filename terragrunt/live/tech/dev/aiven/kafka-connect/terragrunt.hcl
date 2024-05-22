inputs = {
  plan                = "startup-4"
  service_name        = "common-dev-kafka-connect"
  project_name        = dependency.project.outputs.project_name
  source_service_name = dependency.kafka.outputs.name
  project_vpc_id      = dependency.vpc.outputs.network_id
}

include {
  path = find_in_parent_folders()
}

terraform {
  source = "${get_parent_terragrunt_dir()}/..//modules/aiven/kafka-connect/"
}

prevent_destroy = true

dependency "project" {
  config_path = "${get_parent_terragrunt_dir()}/tech/dev/aiven/project"
  mock_outputs = {
    project_name = "invalid"
  }
  mock_outputs_allowed_terraform_commands = ["plan", "destroy"]
}

dependency "vpc" {
  config_path = "${get_parent_terragrunt_dir()}/tech/dev/aiven/vpc"
  mock_outputs = {
    network_id = "invalid"
  }
  mock_outputs_allowed_terraform_commands = ["plan", "destroy"]
}

dependency "kafka" {
  config_path = "${get_parent_terragrunt_dir()}/tech/dev/aiven/kafka"
  mock_outputs = {
    name = "invalid"
  }
  mock_outputs_allowed_terraform_commands = ["plan", "destroy"]
}

