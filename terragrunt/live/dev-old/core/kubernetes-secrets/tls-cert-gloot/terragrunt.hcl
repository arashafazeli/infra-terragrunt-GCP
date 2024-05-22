include {
  path = find_in_parent_folders()
}

terraform {
  source = "${get_parent_terragrunt_dir()}/..//modules/gcp/kubernetes/secret"
}

dependency "namespace" {
  config_path = "../../kubernetes-namespace"
  mock_outputs = {
    name = "invalid"
  }
  mock_outputs_allowed_terraform_commands = ["plan", "destroy"]
}

inputs = {
  namespace    = dependency.namespace.outputs.name
  name         = "gloot-tls-cert"
  service_name = "gloot-tls-cert"
  product      = "core-service"
  team         = "infra-and-ops"
  type         = "kubernetes.io/tls"
  data = {
    "tls.crt" = get_env("GLOOT_TLS_CRT", "invalid-secret")
    "tls.key" = get_env("GLOOT_TLS_KEY", "invalid-secret")
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
