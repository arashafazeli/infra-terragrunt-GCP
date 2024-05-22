dependency "cloudflare-backup-topic" {
  config_path = "${get_parent_terragrunt_dir()}/tech/shared/cloudflare-backup/pub-sub/cloudflare-backup"
  mock_outputs = {
    id = "invalid"
  }
  mock_outputs_allowed_terraform_commands = ["plan", "destroy"]
}

dependency "project" {
  config_path = "${get_parent_terragrunt_dir()}/tech/shared/cloudflare-backup/_project"
  mock_outputs = {
    project_id = "invalid"
  }
  mock_outputs_allowed_terraform_commands = ["plan", "destroy"]
}

inputs = {
  name        = "cloudflare-backup-schedule"
  description = "Schedule to backup all cloudflare dns records"
  topic_name  = dependency.cloudflare-backup-topic.outputs.id
  schedule    = "30 7 * * *"
  message     = "Initial message"
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
