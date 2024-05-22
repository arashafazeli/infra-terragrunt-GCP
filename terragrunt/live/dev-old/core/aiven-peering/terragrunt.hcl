include {
  path = find_in_parent_folders()
}

terraform {
  source = "${get_parent_terragrunt_dir()}/..//modules/gcp/network/vpc-peering"
}

dependency "aiven_peering" {
  config_path = "${get_parent_terragrunt_dir()}/tech/dev/aiven/gcp-dev-old-peering"
  mock_outputs = {
    state_info = {
      to_project_id  = "invalid"
      to_vpc_network = "invalid"
    }
  }
  mock_outputs_allowed_terraform_commands = ["plan", "destroy"]
}

inputs = {
  network_id           = "projects/play-gll-gg/global/networks/default"
  peer_network_id      = "projects/${dependency.aiven_peering.outputs.state_info.to_project_id}/global/networks/${dependency.aiven_peering.outputs.state_info.to_vpc_network}"
  name                 = "aiven-peering-dev"
  export_custom_routes = true
}
