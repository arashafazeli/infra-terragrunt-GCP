include {
  path = find_in_parent_folders()
}

terraform {
  source = "${get_parent_terragrunt_dir()}/..//modules/gcp/workload-identity-federation/"
}


inputs = {
  project_id  = "gloot-automation"
  name        = "terraform-1"
  pool_id     = "terraform"
  provider_id = "github-provider"
  attribute   = "*"
}

generate "providers" {
  path      = "providers.tf"
  if_exists = "overwrite"
  contents  = <<-EOF
    data "google_client_config" "current" {}

    provider "google" {
      project = "gloot-automation"
      region  = "europe-west1"
    }

    provider "google-beta" {
      project = "gloot-automation"
      region  = "europe-west1"
    }
    EOF
}
