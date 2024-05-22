
inputs = {
  plan           = "business-4"
  service_name   = "user-search"
  project_name   = dependency.project.outputs.project_name
  project_vpc_id = dependency.vpc.outputs.network_id
}

include {
  path = find_in_parent_folders()
}

terraform {
  source = "${get_parent_terragrunt_dir()}/..//modules/aiven/opensearch/"
}

prevent_destroy = true

dependency "project" {
  config_path = "${get_parent_terragrunt_dir()}/tech/prod/aiven/project"
  mock_outputs = {
    project_name = "invalid"
  }
  mock_outputs_allowed_terraform_commands = ["plan", "destroy"]
}

dependency "vpc" {
  config_path = "${get_parent_terragrunt_dir()}/tech/prod/aiven/vpc"
  mock_outputs = {
    network_id = "invalid"
  }
  mock_outputs_allowed_terraform_commands = ["plan", "destroy"]
}
