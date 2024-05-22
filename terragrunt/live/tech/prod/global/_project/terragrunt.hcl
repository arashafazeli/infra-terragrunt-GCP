include {
  path = find_in_parent_folders()
}

terraform {
  source = "${get_parent_terragrunt_dir()}/..//modules/gcp/project/"
}

dependency "folder" {
  config_path = "${get_parent_terragrunt_dir()}/tech/prod/_folder"
  mock_outputs = {
    name = "invalid"
  }
  mock_outputs_allowed_terraform_commands = ["plan", "destroy"]
}

inputs = {
  name                          = "global"
  create_app_engine_application = true
  folder                        = dependency.folder.outputs.name
  team                          = "infra-and-ops"
  iam_bindings = {
    "roles/cloudfunctions.developer" = ["serviceAccount:gitlab-ci@gloot-automation.iam.gserviceaccount.com"]
    "roles/iam.serviceAccountUser"   = ["serviceAccount:gitlab-ci@gloot-automation.iam.gserviceaccount.com"]
    "roles/container.developer"      = ["serviceAccount:github-ca-cert-renewal@certificate-management.iam.gserviceaccount.com", "group:payments-team@gloot.com"]
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
