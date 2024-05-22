include {
  path = find_in_parent_folders()
}

terraform {
  source = "${get_parent_terragrunt_dir()}/..//modules/gcp/hosting/web-host-service"
}

dependency "project" {
  config_path = "${get_parent_terragrunt_dir()}/tech/prod/static-hosting/stats-graph/_project"
  mock_outputs = {
    project_id = "invalid"
  }
  mock_outputs_allowed_terraform_commands = ["plan", "destroy"]
}

dependency "static-dns-zone" {
  config_path = "${get_parent_terragrunt_dir()}/tech/prod/static-hosting/dns/static.prod.gloot.com/dns/dns-zone"
  mock_outputs = {
    name     = "invalid"
    project  = "invalid"
    dns_name = "invalid"
  }
  mock_outputs_allowed_terraform_commands = ["plan", "destroy"]
}

inputs = {
  name        = "stats-graph"
  team        = "platform"
  product     = "stats-graph"
  dns_name    = dependency.static-dns-zone.outputs.name
  dns_project = dependency.static-dns-zone.outputs.project
  dns_domain  = dependency.static-dns-zone.outputs.dns_name

  # Optional, adds GCP secrets for pipeline
  github_repository_name = "stats-graph"
}

generate "providers" {
  path      = "providers.tf"
  if_exists = "overwrite"
  contents  = <<-EOF
    provider "google" {
      project = "${dependency.project.outputs.project_id}"
      region  = "europe-west1"
    }
    provider "google-beta" {
      project = "${dependency.project.outputs.project_id}"
      region  = "europe-west1"
    }
    EOF
}
