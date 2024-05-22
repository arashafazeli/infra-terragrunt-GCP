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
  name                          = "github-backup"
  folder                        = dependency.folder.outputs.name
  team                          = "infra-and-ops"
  create_app_engine_application = true
  iam_bindings = {
    "roles/cloudfunctions.developer" = ["serviceAccount:gitlab-ci@gloot-automation.iam.gserviceaccount.com"]
    "roles/iam.serviceAccountUser"   = ["serviceAccount:gitlab-ci@gloot-automation.iam.gserviceaccount.com"]
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
