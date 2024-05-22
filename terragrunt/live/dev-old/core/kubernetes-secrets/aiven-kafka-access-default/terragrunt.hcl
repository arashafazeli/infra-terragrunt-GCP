include {
  path = find_in_parent_folders()
}

terraform {
  source = "${get_parent_terragrunt_dir()}/..//modules/gcp/kubernetes/secret"
}

dependency "aiven-kafka" {
  config_path = "${get_parent_terragrunt_dir()}/tech/dev/aiven/kafka"
  mock_outputs = {
    uri         = "invalid"
    access_key  = "invalid"
    access_cert = "invalid"
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

inputs = {
  name         = "aiven-kafka-access"
  service_name = "kafka"
  product      = "core-service"
  team         = "infra-and-ops"
  data = {
    uri               = dependency.aiven-kafka.outputs.uri
    access_key        = dependency.aiven-kafka.outputs.access_key
    "client_cert.key" = dependency.aiven-kafka.outputs.access_cert
    "ca.crt"          = dependency.aiven-project.outputs.ca_cert
  }
}

generate "providers" {
  path      = "providers.tf"
  if_exists = "overwrite"
  contents  = <<-EOF
    data "google_client_config" "current" {}

    provider "kubernetes" {
      
      host                   = "https://35.195.55.235"
      cluster_ca_certificate = <<CERT
    ${get_env("DEV_OLD_CLUSTER_CA_CERT", "BAD_CA")}
    CERT
      token                  = data.google_client_config.current.access_token
    }

    provider "google" {
      project = "play-gll-gg"
      region  = "europe-west1"
    }
    EOF
}
