include {
  path = find_in_parent_folders()
}

terraform {
  source = "${get_parent_terragrunt_dir()}/..//modules/aiven/prometheus/"
}

prevent_destroy = true

dependency "project" {
  config_path = "${get_parent_terragrunt_dir()}/tech/dev/aiven/project"
  mock_outputs = {
    project_name = "invalid"
  }
  mock_outputs_allowed_terraform_commands = ["plan", "destroy"]
}

inputs = {
  name    = "prometheus"
  project = dependency.project.outputs.project_name
}
