include {
  path = find_in_parent_folders()
}

terraform {
  source = "${get_parent_terragrunt_dir()}/..//modules/gcp/iam/google-service-account"
}
inputs = {
  name      = "chartmuseum"
  namespace = "core"
  roles     = ["roles/storage.objectViewer"]
  labels = {
    "team"    = "infra-and-ops"
    "product" = "gitops"
  }
}

dependency "project" {
  config_path = "${get_parent_terragrunt_dir()}/tech/dev/gnog/_project"
  mock_outputs = {
    project_id = "invalid"
  }
  mock_outputs_allowed_terraform_commands = ["plan", "destroy"]
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

dependency "core" {
  config_path  = "${get_parent_terragrunt_dir()}/tech/dev/gnog/kubernetes/namespace/core/"
  skip_outputs = true
}

generate "providers" {
  path      = "providers.tf"
  if_exists = "overwrite"
  contents  = <<-EOF
    data "google_client_config" "project_id" {}

    provider "kubernetes" {
      
      host                   = "https://${dependency.cluster.outputs.endpoint}"
      cluster_ca_certificate = <<CERT
    ${dependency.cluster.outputs.ca_certificate}
    CERT
      token                  = data.google_client_config.project_id.access_token
    }
    provider "google" {
      project = "${dependency.project.outputs.project_id}"
      region  = "europe-west1"
    }
    EOF
}
