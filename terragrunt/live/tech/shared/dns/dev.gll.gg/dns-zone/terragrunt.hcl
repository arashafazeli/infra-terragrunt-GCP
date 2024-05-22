include {
  path = find_in_parent_folders()
}

terraform {
  source = "${get_parent_terragrunt_dir()}/..//modules/gcp/network/dns/dns-zone/"
}

prevent_destroy = true

dependency "project" {
  config_path = "${get_parent_terragrunt_dir()}/tech/shared/dns/_project"
  mock_outputs = {
    project_id = "invalid"
  }
  mock_outputs_allowed_terraform_commands = ["plan", "destroy"]
}

inputs = {
  name     = "dev-gll-gg"
  dns_name = "dev.gll.gg."
  project  = dependency.project.outputs.project_id
  labels = {
    kubernetes_label_env  = "dev"
    kubernetes_label_team = "infra-and-ops"
  }
}
