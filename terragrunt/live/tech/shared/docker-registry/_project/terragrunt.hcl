include {
  path = find_in_parent_folders()
}

terraform {
  source = "${get_parent_terragrunt_dir()}/..//modules/gcp/project/"
}

prevent_destroy = true

dependency "folder" {
  config_path = "${get_parent_terragrunt_dir()}/tech/shared/_folder"
  mock_outputs = {
    name = "invalid"
  }
  mock_outputs_allowed_terraform_commands = ["plan", "destroy"]
}

inputs = {
  name                      = "docker-registry"
  folder                    = dependency.folder.outputs.name
  team                      = "infra-and-ops"
  create_container_registry = true
  iam_bindings = {
    "roles/storage.admin" = ["serviceAccount:gitlab-ci@gloot-automation.iam.gserviceaccount.com"]
  }
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
