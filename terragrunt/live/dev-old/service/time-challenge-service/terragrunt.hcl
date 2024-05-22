include {
  path = find_in_parent_folders()
}

terraform {
  source = "${get_parent_terragrunt_dir()}/..//modules/gcp/kubernetes/service"
}

inputs = {
  cluster_name     = "dev-gll-play"
  team             = "platform-core"
  product          = "gnog"
  service_name     = "time-challenge-service-dev"
  db_user_name     = "time-challenge-service"
  db_instance_type = "db-f1-micro"
  db_name          = "time-challenge-service"
  postgres_version = "POSTGRES_11"
  gloot_roles      = ["USER"]
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

    provider "google-beta" {
      project = "play-gll-gg"
      region  = "europe-west1"
    }
    EOF
}
