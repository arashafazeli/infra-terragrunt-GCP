include {
  path = find_in_parent_folders()
}

terraform {
  source = "${get_parent_terragrunt_dir()}/..//modules/gcp/kubernetes/common"
}

dependency "project" {
  config_path = "${get_parent_terragrunt_dir()}/tech/dev/global/_project/"
  mock_outputs = {
    project_id = "invalid"
  }
  mock_outputs_allowed_terraform_commands = ["plan", "destroy"]
}

dependency "cluster" {
  config_path = "${get_parent_terragrunt_dir()}/tech/dev/global/kubernetes/cluster/"
  mock_outputs = {
    name           = "invalid"
    endpoint       = "invalid"
    ca_certificate = "invalid"
  }
  mock_outputs_allowed_terraform_commands = ["plan", "destroy"]
}

inputs = {
  service_name = "core-service"
  team         = "infra-and-ops"
  product      = "core-service"
  cluster_name = dependency.cluster.outputs.name
}

generate "providers" {
  path      = "providers.tf"
  if_exists = "overwrite"
  contents  = <<-EOF
    data "google_client_config" "current" {}

    provider "kubernetes" {
      
      host                   = "https://${dependency.cluster.outputs.endpoint}"
      cluster_ca_certificate = <<CERT
    ${dependency.cluster.outputs.ca_certificate}
    CERT
      token                  = data.google_client_config.current.access_token
    }

    provider "google" {
      project = "${dependency.project.outputs.project_id}"
      region  = "europe-west1"
    }
    EOF
}
