include {
  path = find_in_parent_folders()
}

terraform {
  source = "${get_parent_terragrunt_dir()}/..//modules/gcp/project/"
}

dependency "folder" {
  config_path = "${get_parent_terragrunt_dir()}/tech/prod/static-hosting/dns/_folder"
  mock_outputs = {
    name = "invalid"
  }
  mock_outputs_allowed_terraform_commands = ["plan", "destroy"]
}

inputs = {
  name             = "static-prod-gloot-com"
  folder           = dependency.folder.outputs.name
  team             = "infra-and-ops"
  random_id_length = 1
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
