include {
  path = find_in_parent_folders()
}

terraform {
  source = "${get_parent_terragrunt_dir()}/..//modules/gcp/monitoring/notification-channel"
}

dependency "project" {
  config_path = "${get_parent_terragrunt_dir()}/tech/shared/github-backup/_project"
  mock_outputs = {
    project_id = "invalid"
  }
  mock_outputs_allowed_terraform_commands = ["plan", "destroy"]
}

inputs = {
  name = "opsgenie-notification-channel-shared-github"
  type = "webhook_tokenauth"
  labels = {
    url = "https://api.eu.opsgenie.com/v1/json/googlestackdriver?apiKey=${get_env("BACKUP_ALERT_OPSGENIE_STACKDRIVER_TOKEN", "INVALID")}"
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
