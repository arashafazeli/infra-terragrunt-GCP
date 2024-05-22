include {
  path = find_in_parent_folders()
}

terraform {
  source = "${get_parent_terragrunt_dir()}/..//modules/gcp/folder/"
}

prevent_destroy = true

dependency "folder" {
  config_path = "${get_parent_terragrunt_dir()}/tech/_folder"
  mock_outputs = {
    name = "invalid"
  }
  mock_outputs_allowed_terraform_commands = ["plan", "destroy"]
}

inputs = {
  name   = "dev"
  parent = dependency.folder.outputs.name
}

generate "providers" {
  path      = "providers.tf"
  if_exists = "overwrite"
  contents  = <<-EOF
    data "google_client_config" "current" {}

    provider "google" {
      project = "gloot-automation"
      region  = "europe-west1"
    }
    EOF
}
