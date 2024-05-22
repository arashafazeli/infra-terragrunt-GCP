include {
  path = find_in_parent_folders()
}

terraform {
  source = "${get_parent_terragrunt_dir()}/..//modules/gcp/folder/"
}

dependency "folder" {
  config_path = "${get_parent_terragrunt_dir()}/tech/dev/_folder"
  mock_outputs = {
    name = "invalid"
  }
  mock_outputs_allowed_terraform_commands = ["plan", "destroy"]
}

inputs = {
  name   = "static-hosting"
  parent = dependency.folder.outputs.name
  iam_bindings = {
    "roles/storage.objectAdmin" = ["serviceAccount:gitlab-ci@gloot-automation.iam.gserviceaccount.com"]
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
