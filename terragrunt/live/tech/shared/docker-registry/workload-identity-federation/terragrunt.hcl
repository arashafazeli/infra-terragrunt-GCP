include {
  path = find_in_parent_folders()
}

terraform {
  source = "${get_parent_terragrunt_dir()}/..//modules/gcp/workload-identity-federation/"
}

dependency "project" {
  config_path = "${get_parent_terragrunt_dir()}/tech/shared/docker-registry/_project/"
  mock_outputs = {
    project_id = "invalid"
  }
  mock_outputs_allowed_terraform_commands = ["plan", "destroy"]
}

inputs = {
  project_id  = dependency.project.outputs.project_id
  name        = "workload-identity-service"
  pool_id     = "github-pool"
  provider_id = "github-provider"
  attribute   = "*"
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

    provider "google-beta" {
      project = "${dependency.project.outputs.project_id}"
      region  = "europe-west1"
    }
    EOF
}
