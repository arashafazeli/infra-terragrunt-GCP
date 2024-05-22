include {
  path = find_in_parent_folders()
}

terraform {
  source = "${get_parent_terragrunt_dir()}/..//modules/gcp/kubernetes/service"
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

dependency "vpc" {
  config_path = "${get_parent_terragrunt_dir()}/tech/dev/global/network/vpc"
  mock_outputs = {
    network = "invalid"
  }
  mock_outputs_allowed_terraform_commands = ["plan", "destroy"]
}

inputs = {
  cluster_name               = dependency.cluster.outputs.name
  network                    = dependency.vpc.outputs.network
  team                       = "payments"
  product                    = "payments"
  service_name               = "ban-point-service"
  db_user_name               = "ban-point-service-user"
  db_instance_type           = "db-custom-1-4096"
  db_name                    = "ban-point-service"
  postgres_version           = "POSTGRES_14"
  db_enable_failover_replica = false
  gloot_roles                = ["USER", "user.block", "user.unblock"]
  gloot_refresh_tokens = {
    core = ["Terraform"]
  }
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
