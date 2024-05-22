dependency "badge-publish-topic" {
  config_path = "${get_parent_terragrunt_dir()}/prod-old/service/badge-publisher/pub-sub"
  mock_outputs = {
    id = "invalid"
  }
  mock_outputs_allowed_terraform_commands = ["plan", "destroy"]
}

inputs = {
  name        = "badge-publish-schedule"
  description = "Schedule to trigger badge-publish"
  topic_name  = dependency.badge-publish-topic.outputs.id
  schedule    = "0 */2 * * *"
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
      project = "play-gll-gg"
      region  = "europe-west1"
    }
    EOF
}
