include {
  path = find_in_parent_folders()
}

terraform {
  source = "${get_parent_terragrunt_dir()}/..//modules/gcp/project/"
}

dependency "folder" {
  config_path = "${get_parent_terragrunt_dir()}/tech/dev/_folder"
  mock_outputs = {
    name = "invalid"
  }
  mock_outputs_allowed_terraform_commands = ["plan", "destroy"]
}

inputs = {
  name   = "bi-dataflow"
  folder = dependency.folder.outputs.name
  team   = "infra-and-ops"
  iam_bindings = {
    "roles/owner"                     = ["group:tech@gloot.com", "group:insights@gloot.com"]
    "roles/viewer"                    = ["serviceAccount:gitlab-ci@gloot-automation.iam.gserviceaccount.com"]
    "roles/dataflow.worker"           = ["serviceAccount:gitlab-ci@gloot-automation.iam.gserviceaccount.com"]
    "roles/dataflow.developer"        = ["serviceAccount:gitlab-ci@gloot-automation.iam.gserviceaccount.com"]
    "roles/iam.serviceAccountUser"    = ["serviceAccount:gitlab-ci@gloot-automation.iam.gserviceaccount.com"]
    "roles/cloudbuild.builds.builder" = ["serviceAccount:gitlab-ci@gloot-automation.iam.gserviceaccount.com"]
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
