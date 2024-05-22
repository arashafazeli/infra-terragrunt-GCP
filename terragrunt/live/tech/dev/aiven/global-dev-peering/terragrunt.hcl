include {
  path = find_in_parent_folders()
}

terraform {
  source = "${get_parent_terragrunt_dir()}/..//modules/aiven/vpc-peering/"
}

prevent_destroy = true

dependency "vpc" {
  config_path = "${get_parent_terragrunt_dir()}/tech/dev/aiven/vpc"
  mock_outputs = {
    network_id = "invalid"
  }
  mock_outputs_allowed_terraform_commands = ["plan", "destroy"]
}

dependency "gcp-project" {
  config_path = "${get_parent_terragrunt_dir()}/tech/dev/global/_project/"
  mock_outputs = {
    project_id = "invalid"
  }
  mock_outputs_allowed_terraform_commands = ["plan", "destroy"]
}

dependency "gcp-vpc" {
  config_path = "${get_parent_terragrunt_dir()}/tech/dev/global/network/vpc"
  mock_outputs = {
    name = "invalid"
  }
  mock_outputs_allowed_terraform_commands = ["plan", "destroy"]
}

#Cluster will create VPC peering, avoid creating two peerings at the same time
dependencies {
  paths = ["${get_parent_terragrunt_dir()}/tech/dev/global/kubernetes/cluster/"]
}

inputs = {
  vpc_id         = dependency.vpc.outputs.network_id
  gcp_project_id = dependency.gcp-project.outputs.project_id
  peer_vpc       = dependency.gcp-vpc.outputs.name

}
