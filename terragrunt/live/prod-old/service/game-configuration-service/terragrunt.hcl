include {
  path = find_in_parent_folders()
}

terraform {
  source = "${get_parent_terragrunt_dir()}/..//modules/gcp/kubernetes/service"
}

inputs = {
  cluster_name     = "prod-gll-play"
  team             = "platform-core"
  product          = "gnog"
  service_name     = "game-configuration-service-p"
  db_user_name     = "game-configuration-user"
  db_instance_type = "db-g1-small"
  db_name          = "game-configuration-service"
  postgres_version = "POSTGRES_11"
  gloot_roles      = ["USER"]
  gloot_refresh_tokens = {
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
