include {
  path = find_in_parent_folders()
}

terraform {
  source = "${get_parent_terragrunt_dir()}/..//modules/gcp/network/dns/dns-zone/"
}

dependency "project" {
  config_path = "${get_parent_terragrunt_dir()}/tech/dev/global/_project/"
  mock_outputs = {
    project_id = "invalid"
  }
  mock_outputs_allowed_terraform_commands = ["plan", "destroy"]
}

inputs = {
  name     = "global-dev-gloot-com"
  dns_name = "global.dev.gloot.com."
  labels = {
    kubernetes_label_env  = "dev"
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
