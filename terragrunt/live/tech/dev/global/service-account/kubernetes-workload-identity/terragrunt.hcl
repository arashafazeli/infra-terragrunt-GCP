include {
  path = find_in_parent_folders()
}

terraform {
  source = "${get_parent_terragrunt_dir()}/..//modules/gcp/iam/google-service-account-standalone"
}

inputs = {
  name      = "kubernetes-workload-identity"
  namespace = "default"
  roles     = ["roles/container.developer"]
  labels = {
    "team"    = "infra-and-ops"
    "product" = "workload-identity"
  }
}

dependency "project" {
  config_path = "${get_parent_terragrunt_dir()}/tech/dev/global/_project"
  mock_outputs = {
    project_id = "invalid"
  }
  mock_outputs_allowed_terraform_commands = ["plan", "destroy"]
}

dependency "core" {
  config_path  = "${get_parent_terragrunt_dir()}/tech/dev/global/kubernetes/namespace/core/"
  skip_outputs = true
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
