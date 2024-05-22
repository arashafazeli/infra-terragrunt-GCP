include {
  path = find_in_parent_folders()
}

terraform {
  source = "${get_parent_terragrunt_dir()}/..//modules/gcp/kubernetes/service"
}

inputs = {
  cluster_name     = "prod-gll-play"
  team             = "platform-core"
  product          = "gll"
  service_name     = "tournament-service-p"
  db_user_name     = "tournament-user"
  db_instance_type = "db-custom-6-10240"
  db_name          = "tournament-service"
  postgres_version = "POSTGRES_11"
  gloot_roles      = ["USER", "GLL_SERVER", "FEATURE_VIEW_BLOCKS", "FEATURE_COIN_VIEWER"]
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

    provider "google-beta" {
      project = "play-gll-gg"
      region  = "europe-west1"
    }
    EOF
}
