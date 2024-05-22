include {
  path = find_in_parent_folders()
}

terraform {
  source = "${get_parent_terragrunt_dir()}/..//modules/gcp/folder/"
}

prevent_destroy = true

dependency "tech-folder" {
  config_path = "${get_parent_terragrunt_dir()}/tech/_folder"
}

inputs = {
  name   = "shared"
  parent = dependency.tech-folder.outputs.name
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
    EOF
}
