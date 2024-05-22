dependency "project" {
  config_path = "${get_parent_terragrunt_dir()}/tech/dev/global/_project"
  mock_outputs = {
    project_id = "invalid"
  }
  mock_outputs_allowed_terraform_commands = ["plan", "destroy"]
}

inputs = {
  name        = "announce-fika"
  description = "Trigger announce endpoint"
  http_uri    = "https://edge.global.dev.gloot.com/fika-bot/fika/announce"
  schedule    = "0 9 * * FRI"
}

include {
  path = find_in_parent_folders()
}

terraform {
  source = "${get_parent_terragrunt_dir()}/..//modules/gcp/scheduler/"
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
