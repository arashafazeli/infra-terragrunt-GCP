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

dependency "dev-dns-zone" {
  config_path = "${get_parent_terragrunt_dir()}/tech/shared/dns/dev.gloot.com/dns-zone"
  mock_outputs = {
    name = "invalid"
  }
  mock_outputs_allowed_terraform_commands = ["plan", "destroy"]
}

inputs = {
  name         = "admin.dev.gloot.com."
  type         = "CNAME"
  ttl          = 300
  rrdatas      = ["admin.global.dev.gloot.com."]
  managed_zone = dependency.dev-dns-zone.outputs.name
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
