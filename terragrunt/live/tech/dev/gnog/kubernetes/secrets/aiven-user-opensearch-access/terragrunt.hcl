include {
  path = find_in_parent_folders()
}

terraform {
  source = "${get_parent_terragrunt_dir()}/..//modules/gcp/kubernetes/secret"
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

dependency "aiven-opensearch" {
  config_path = "${get_parent_terragrunt_dir()}/tech/dev/aiven/opensearch/user-search"
  mock_outputs = {
    host     = "invalid"
    port     = "invalid"
    username = "invalid"
    password = "invalid"
    uri      = "invalid"
  }
  mock_outputs_allowed_terraform_commands = ["plan", "destroy"]
}

dependency "aiven-project" {
  config_path = "${get_parent_terragrunt_dir()}/tech/dev/aiven/project"
  mock_outputs = {
    ca_cert = "invalid"
  }
  mock_outputs_allowed_terraform_commands = ["plan", "destroy"]
}

dependency "project" {
  config_path = "${get_parent_terragrunt_dir()}/tech/dev/gnog/_project/"
  mock_outputs = {
    project_id = "invalid"
  }
  mock_outputs_allowed_terraform_commands = ["plan", "destroy"]
}

inputs = {
  name         = "aiven-user-opensearch-access"
  service_name = "opensearch"
  namespace    = "default"
  product      = "core-service"
  team         = "infra-and-ops"
  data = {
    host     = dependency.aiven-opensearch.outputs.host
    port     = dependency.aiven-opensearch.outputs.port
    username = dependency.aiven-opensearch.outputs.username
    password = dependency.aiven-opensearch.outputs.password
    uri      = dependency.aiven-opensearch.outputs.uri
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
     EOF
}
