include {
  path = find_in_parent_folders()
}

terraform {
  source = "${get_parent_terragrunt_dir()}/..//modules/gcp/network/vpc-peering"
}

dependency "google_vpc" {
  config_path = "${get_parent_terragrunt_dir()}/tech/dev/global/network/vpc"
  mock_outputs = {
    id = "projects/invalidproject/global/networks/invalidnetwork"
  }
  mock_outputs_allowed_terraform_commands = ["plan", "destroy"]
}

dependency "aiven_peering" {
  config_path = "${get_parent_terragrunt_dir()}/tech/dev/aiven/global-dev-peering"
  mock_outputs = {
    state_info = {
      to_project_id  = "invalid"
      to_vpc_network = "invalid"
    }
  }
  mock_outputs_allowed_terraform_commands = ["plan", "destroy"]
}

inputs = {
  network_id      = dependency.google_vpc.outputs.id
  peer_network_id = "projects/${dependency.aiven_peering.outputs.state_info.to_project_id}/global/networks/${dependency.aiven_peering.outputs.state_info.to_vpc_network}"
  name            = "aiven-peering-dev"
}
