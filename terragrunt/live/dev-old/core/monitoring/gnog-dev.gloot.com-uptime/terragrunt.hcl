include {
  path = find_in_parent_folders()
}

terraform {
  source = "${get_parent_terragrunt_dir()}/..//modules/gcp/monitoring/uptime-check"
}

dependency "notification-channel" {
  config_path = "${get_parent_terragrunt_dir()}/dev-old/core/monitoring/stackdriver-opsgenie-notification-channel"
  mock_outputs = {
    name = "invalid"
  }
  mock_outputs_allowed_terraform_commands = ["plan", "destroy"]
}

inputs = {
  host                  = "gnog-dev.gloot.com"
  paths                 = ["/"]
  notification_channels = [dependency.notification-channel.outputs.name]
}

generate "providers" {
  path      = "providers.tf"
  if_exists = "overwrite"
  contents  = <<-EOF
    provider "google" {
      project = "play-gll-gg"
      region  = "europe-west1"
    }
    EOF
}
