include {
  path = find_in_parent_folders()
}

terraform {
  source = "${get_parent_terragrunt_dir()}/..//modules/gcp/kubernetes/namespace"
}

inputs = {
  team         = "infra-and-ops"
  product      = "core-service"
  cluster_name = "prod-gll-play"
  namespace_config = {
    name = "core"
  }
}

generate "providers" {
  path      = "providers.tf"
  if_exists = "overwrite"
  contents  = <<-EOF
    data "google_client_config" "current" {}

    provider "kubernetes" {
      
      host                   = "https://35.187.183.228"
      cluster_ca_certificate = <<CERT
    ${get_env("PROD_OLD_CLUSTER_CA_CERT", "BAD_CA")}
    CERT
      token                  = data.google_client_config.current.access_token
    }

    provider "google" {
      project = "play-gll-gg"
      region  = "europe-west1"
    }
    EOF
}
