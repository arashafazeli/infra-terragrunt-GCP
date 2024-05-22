dependency "github-backup-topic" {
  config_path = "${get_parent_terragrunt_dir()}/tech/shared/github-backup/pub-sub/github-backup"
  mock_outputs = {
    id = "invalid"
  }
  mock_outputs_allowed_terraform_commands = ["plan", "destroy"]
}

dependency "project" {
  config_path = "${get_parent_terragrunt_dir()}/tech/shared/github-backup/_project"
  mock_outputs = {
    project_id = "invalid"
  }
  mock_outputs_allowed_terraform_commands = ["plan", "destroy"]
}

inputs = {
  name        = "github-backup-schedule"
  description = "Schedule to backup all github repositories"
  topic_name  = dependency.github-backup-topic.outputs.id
  schedule    = "10 9 * * 0"
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
