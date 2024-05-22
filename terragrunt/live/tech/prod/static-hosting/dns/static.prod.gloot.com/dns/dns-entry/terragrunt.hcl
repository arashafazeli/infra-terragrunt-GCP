include {
  path = find_in_parent_folders()
}

terraform {
  source = "${get_parent_terragrunt_dir()}/..//modules/gcp/network/dns/dns-entry/"
}

dependency "project" {
  config_path = "${get_parent_terragrunt_dir()}/tech/shared/dns/_project/"
  mock_outputs = {
    project_id = "invalid"
  }
  mock_outputs_allowed_terraform_commands = ["plan", "destroy"]
}

dependency "prod-dns-zone" {
  config_path = "${get_parent_terragrunt_dir()}/tech/shared/dns/prod.gloot.com/dns-zone"
  mock_outputs = {
    name = "invalid"
  }
  mock_outputs_allowed_terraform_commands = ["plan", "destroy"]
}

dependency "static-prod-dns-zone" {
  config_path = "${get_parent_terragrunt_dir()}/tech/prod/static-hosting/dns/static.prod.gloot.com/dns/dns-zone"
  mock_outputs = {
    nameservers = ["invalid"]
  }
  mock_outputs_allowed_terraform_commands = ["plan", "destroy"]
}

inputs = {
  name         = "static.prod.gloot.com."
  type         = "NS"
  ttl          = 21600
  rrdatas      = dependency.static-prod-dns-zone.outputs.nameservers
  managed_zone = dependency.prod-dns-zone.outputs.name
}

generate "providers" {
  path      = "providers.tf"
  if_exists = "overwrite"
  contents  = <<-EOF
    provider "google" {
      project = "${dependency.project.outputs.project_id}"
      region  = "europe-west1"
    }
    EOF
}
