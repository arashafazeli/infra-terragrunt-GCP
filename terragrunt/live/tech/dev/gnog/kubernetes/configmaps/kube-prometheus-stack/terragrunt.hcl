include {
  path = find_in_parent_folders()
}

terraform {
  source = "${get_parent_terragrunt_dir()}/..//modules/gcp/kubernetes/configmap"
}

dependency "project" {
  config_path = "${get_parent_terragrunt_dir()}/tech/dev/gnog/_project/"
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

dependency "dns-zone" {
  config_path = "${get_parent_terragrunt_dir()}/tech/dev/gnog/network/dns/gnog.dev.gloot.com/dns-zone"
  mock_outputs = {
    dns_name = "invalid"
  }
  mock_outputs_allowed_terraform_commands = ["plan", "destroy"]
}

#Flux needs to create flux-system namespace
dependencies {
  paths = ["${get_parent_terragrunt_dir()}/tech/dev/gnog/kubernetes/services/flux"]
}

inputs = {
  name         = "kube-prometheus-stack-values"
  namespace    = "flux-system"
  team         = "infra-and-ops"
  product      = "core-service"
  service_name = "kube-prometheus-stack"
  data = {
    "values.yaml" = <<-EOT
    kube-prometheus-stack:
      prometheus:
        prometheusSpec:
          externalUrl: "https://prometheus.${dependency.dns-zone.outputs.dns_name}"
      alertmanager:
        alertmanagerSpec:
          externalUrl: "https://alertmanager.${dependency.dns-zone.outputs.dns_name}"
    EOT
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
