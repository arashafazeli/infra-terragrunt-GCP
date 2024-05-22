include {
  path = find_in_parent_folders()
}

terraform {
  source = "${get_parent_terragrunt_dir()}/..//modules/gcp/kubernetes/service"
}

dependency "project" {
  config_path = "${get_parent_terragrunt_dir()}/tech/dev/gnog/_project/"
  mock_outputs = {
    project_id = "invalid"
  }
  mock_outputs_allowed_terraform_commands = ["plan", "destroy"]
}

dependency "cluster" {
  config_path = "${get_parent_terragrunt_dir()}/tech/dev/gnog/kubernetes/cluster/"
  mock_outputs = {
    name           = "invalid"
    endpoint       = "invalid"
    ca_certificate = "invalid"
  }
  mock_outputs_allowed_terraform_commands = ["plan", "destroy"]
}

dependency "vpc" {
  config_path = "${get_parent_terragrunt_dir()}/tech/dev/gnog/network/vpc"
  mock_outputs = {
    network = "invalid"
  }
  mock_outputs_allowed_terraform_commands = ["plan", "destroy"]
}

inputs = {
  cluster_name               = dependency.cluster.outputs.name
  network                    = dependency.vpc.outputs.network
  team                       = "games-team"
  product                    = "gnog"
  service_name               = "valorant-api-provider-service"
  db_user_name               = "valorant-api-provider-user"
  db_instance_type           = "db-f1-micro"
  postgres_version           = "POSTGRES_14"
  db_name                    = "valorant-api-provider-service"
  db_enable_failover_replica = false
  gloot_roles                = ["USER"]
  gloot_refresh_tokens = {
    core = ["SUPER_USER"]
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
