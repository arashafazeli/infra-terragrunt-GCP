dependency "old-delete-topic" {
  config_path = "${get_parent_terragrunt_dir()}/tech/shared/playground-admin/pub-sub/old-project-delete"
  mock_outputs = {
    id = "invalid"
  }
  mock_outputs_allowed_terraform_commands = ["plan", "destroy"]
}

dependency "project" {
  config_path = "${get_parent_terragrunt_dir()}/tech/shared/playground-admin/_project"
  mock_outputs = {
    project_id = "invalid"
  }
  mock_outputs_allowed_terraform_commands = ["plan", "destroy"]
}

inputs = {
  name        = "old-project-delete-schedule"
  description = "Schedule to delete old projects"
  topic_name  = dependency.old-delete-topic.outputs.id
  schedule    = "0 */12 * * *"
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
