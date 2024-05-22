include {
  path = find_in_parent_folders()
}

terraform {
  source = "${get_parent_terragrunt_dir()}/..//modules/gcp/network/dns/dns-zone/"
}

dependency "project" {
  config_path = "${get_parent_terragrunt_dir()}/tech/prod/static-hosting/dns/static.prod.gloot.com/_project"
  mock_outputs = {
    project_id = "invalid"
  }
  mock_outputs_allowed_terraform_commands = ["plan", "destroy"]
}

inputs = {
  name     = "static-prod-gloot-com"
  dns_name = "static.prod.gloot.com."
  labels = {
    kubernetes_label_env  = "prod"
    kubernetes_label_team = "infra-and-ops"
  }
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
