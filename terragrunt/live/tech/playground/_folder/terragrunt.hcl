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

dependency "project" {
  config_path = "${get_parent_terragrunt_dir()}/tech/shared/playground-admin/_project"
  mock_outputs = {
    app_engine_default_service_account_email = "invalid"
  }
  mock_outputs_allowed_terraform_commands = ["plan", "destroy"]
}

inputs = {
  name   = "playground"
  parent = dependency.folder.outputs.name
  iam_bindings = {
    "roles/editor"                         = ["group:tech@gloot.com", "group:insights@gloot.com"]
    "roles/resourcemanager.folderAdmin"    = ["group:operations-admins@gloot.com"]
    "roles/billing.projectManager"         = ["serviceAccount:${dependency.project.outputs.app_engine_default_service_account_email}"]
    "roles/viewer"                         = ["serviceAccount:${dependency.project.outputs.app_engine_default_service_account_email}"]
    "roles/resourcemanager.projectDeleter" = ["serviceAccount:${dependency.project.outputs.app_engine_default_service_account_email}"]
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
