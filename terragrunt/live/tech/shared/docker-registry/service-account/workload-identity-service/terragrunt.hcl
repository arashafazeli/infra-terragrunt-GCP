include {
  path = find_in_parent_folders()
}

terraform {
  source = "${get_parent_terragrunt_dir()}/..//modules/gcp/iam/google-service-account-standalone"
}

inputs = {
  name  = "workload-identity-service"
  roles = ["roles/artifactregistry.reader", "roles/artifactregistry.writer", "roles/storage.admin"]
}

dependency "project" {
  config_path = "${get_parent_terragrunt_dir()}/tech/shared/docker-registry/_project"
  mock_outputs = {
    project_id = "invalid"
  }
  mock_outputs_allowed_terraform_commands = ["plan", "destroy"]
}

generate "providers" {
  path      = "providers.tf"
  if_exists = "overwrite"
  contents  = <<-EOF
    data "google_client_config" "current" {}

    provider "google" {
      project = "${dependency.project.outputs.project_id}"
      region  = "europe-west1"
    }
    EOF
}
