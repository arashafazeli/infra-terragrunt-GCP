include {
  path = find_in_parent_folders()
}

terraform {
  source = "${get_parent_terragrunt_dir()}/..//modules/aiven/project/"
}

prevent_destroy = true

dependency "account" {
  config_path = "${get_parent_terragrunt_dir()}/tech/shared/aiven/account"
  mock_outputs = {
    account_id = "invalid"
  }
  mock_outputs_allowed_terraform_commands = ["plan", "destroy"]
}

inputs = {
  project_name = "common-prod"
  parent_id    = dependency.account.outputs.account_id
}
