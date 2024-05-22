inputs = {
  name        = "project-created"
  description = "Log when a new project is created in Playground folder"
  folder      = dependency.folder.outputs.name
  destination = "pubsub.googleapis.com/${dependency.pub_sub_topic.outputs.id}"
  filter      = "logName=\"${dependency.folder.outputs.name}/logs/cloudaudit.googleapis.com%2Factivity\" AND protoPayload.methodName=\"CreateProject\" AND protoPayload.\"@type\"=\"type.googleapis.com/google.cloud.audit.AuditLog\" AND resource.type=\"project\""
  iam_binding = {
    project = dependency.project.outputs.project_id
    role    = "roles/pubsub.publisher"
  }
}

include {
  path = find_in_parent_folders()
}

terraform {
  source = "${get_parent_terragrunt_dir()}/..//modules/gcp/logging/folder-sink"
}

dependency "project" {
  config_path = "${get_parent_terragrunt_dir()}/tech/shared/playground-admin/_project"
  mock_outputs = {
    project_id = "invalid"
  }
  mock_outputs_allowed_terraform_commands = ["plan", "destroy"]
}

dependency "folder" {
  config_path = "${get_parent_terragrunt_dir()}/tech/playground/_folder"
  mock_outputs = {
    name = "invalid"
  }
  mock_outputs_allowed_terraform_commands = ["plan", "destroy"]
}

dependency "pub_sub_topic" {
  config_path = "${get_parent_terragrunt_dir()}/tech/shared/playground-admin/pub-sub/topic-project-created"
  mock_outputs = {
    id = "invalid"
  }
  mock_outputs_allowed_terraform_commands = ["plan", "destroy"]
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
