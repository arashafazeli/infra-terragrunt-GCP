include {
  path = find_in_parent_folders()
}

terraform {
  source = "${get_parent_terragrunt_dir()}/..//modules/gcp/kubernetes/service"
}

dependency "project" {
  config_path = "${get_parent_terragrunt_dir()}/tech/prod/gnog/_project/"
  mock_outputs = {
    project_id = "invalid"
  }
  mock_outputs_allowed_terraform_commands = ["plan", "destroy"]
}

dependency "cluster" {
  config_path = "${get_parent_terragrunt_dir()}/tech/prod/gnog/kubernetes/cluster/"
  mock_outputs = {
    name           = "invalid"
    endpoint       = "invalid"
    ca_certificate = "invalid"
  }
  mock_outputs_allowed_terraform_commands = ["plan", "destroy"]
}

dependency "vpc" {
  config_path = "${get_parent_terragrunt_dir()}/tech/prod/gnog/network/vpc"
  mock_outputs = {
    network = "invalid"
  }
  mock_outputs_allowed_terraform_commands = ["plan", "destroy"]
}

inputs = {
  cluster_name = dependency.cluster.outputs.name
  network      = dependency.vpc.outputs.network
  team         = "platform-core"
  product      = "gnog"
  service_name = "test-service"
  #db_user_name     = "stats-service"
  #db_instance_type = "db-custom-4-10240"
  #db_name          = "stats"
  #postgres_version = "POSTGRES_11"
  gloot_roles = ["USER", "user.block", "user.view-extended"]
  gloot_refresh_tokens = {
    core = ["Terraform"]
  }
  deletion_protection = false
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

    provider "google-beta" {
      project = "${dependency.project.outputs.project_id}"
      region  = "europe-west1"
    }
    EOF
}
