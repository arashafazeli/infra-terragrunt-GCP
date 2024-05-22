include {
  path = find_in_parent_folders()
}

terraform {
  source = "${get_parent_terragrunt_dir()}/..//modules/gcp/kubernetes/secret"
}

dependency "cluster" {
  config_path = "${get_parent_terragrunt_dir()}/tech/dev/global/kubernetes/cluster/"
  mock_outputs = {
    name           = "invalid"
    endpoint       = "invalid"
    ca_certificate = "invalid"
  }
  mock_outputs_allowed_terraform_commands = ["plan", "destroy"]
}

dependency "service_account" {
  config_path = "${get_parent_terragrunt_dir()}/tech/dev/global/service-account/thanos"
  mock_outputs = {
    name            = "invalid"
    service_account = "invalid"
    credentials     = "invalid"
  }
  mock_outputs_allowed_terraform_commands = ["plan", "destroy"]
}

dependency "project" {
  config_path = "${get_parent_terragrunt_dir()}/tech/dev/global/_project/"
  mock_outputs = {
    project_id = "invalid"
  }
  mock_outputs_allowed_terraform_commands = ["plan", "destroy"]
}

inputs = {
  name         = "thanos-service-account"
  product      = "monitoring"
  team         = "infra-and-ops"
  service_name = "grafana"
  namespace    = "flux-system"
  data = {
    "values.yaml" = <<-EOF
      thanos:
        objstoreConfig: |-
          type: GCS
          config:
            bucket: "global-dev-thanos"
            service_account: |-
              ${indent(8, trimspace(dependency.service_account.outputs.credentials))}
    EOF
  }
}

generate "providers" {
  path      = "providers.tf"
  if_exists = "overwrite"
  contents  = <<-EOF
    data "google_client_config" "current" {}

    provider "kubernetes" {
      
      host                   = "https://${dependency.cluster.outputs.endpoint}"
      cluster_ca_certificate = <<CERT
    ${dependency.cluster.outputs.ca_certificate}
    CERT
      token                  = data.google_client_config.current.access_token
    }

    provider "google" {
      project = "${dependency.project.outputs.project_id}"
      region  = "europe-west1"
    }
    EOF
}
