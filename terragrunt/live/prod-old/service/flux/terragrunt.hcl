include {
  path = find_in_parent_folders()
}

terraform {
  source = "${get_parent_terragrunt_dir()}/..//modules/gcp/kubernetes/flux"
}

inputs = {
  project                = "play-gll-gg"
  region                 = "europe-west1"
  team                   = "infra-and-ops"
  product                = "core-service"
  cluster_name           = "prod-gll-play"
  docker_registry_bucket = "not-used-in-prod-old"
  flux_config_sets = {
    "git.branch" = "master"
    "git.path"   = "releases/prod-old"
  }
  helm_operator_config_sets = {
    "git.defaultRef" = "master"
  }
}

generate "providers" {
  path      = "providers.tf"
  if_exists = "overwrite"
  contents  = <<-EOF
    data "google_client_config" "current" {}

    data "github_repository" "flux-repo" {
      name = "infra-flux"
    }

    provider "kubernetes" {
      
      host                   = "https://35.187.183.228"
      cluster_ca_certificate = <<CERT
    ${get_env("PROD_OLD_CLUSTER_CA_CERT", "BAD_CA")}
    CERT
      token                  = data.google_client_config.current.access_token
    }

    provider "helm" {
      kubernetes {
        host                   = "https://35.187.183.228"
        cluster_ca_certificate = <<CERT
    ${get_env("PROD_OLD_CLUSTER_CA_CERT", "BAD_CA")}
    CERT
        token                  = data.google_client_config.current.access_token
        
      }
    }

    provider "google" {
      project = "play-gll-gg"
      region  = "europe-west1"
    }
    EOF
}
