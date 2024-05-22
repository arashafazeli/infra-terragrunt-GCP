include {
  path = find_in_parent_folders()
}

terraform {
  source = "${get_parent_terragrunt_dir()}/..//modules/gcp/kubernetes/cluster"
}

dependency "vpc" {
  config_path = "${get_parent_terragrunt_dir()}/tech/dev/global/network/vpc"
  mock_outputs = {
    network                              = "invalid"
    private                              = "invalid"
    public_subnetwork                    = "invalid"
    gke_cluster_secondary_ip_range_name  = "invalid"
    gke_services_secondary_ip_range_name = "invalid"
  }
  mock_outputs_allowed_terraform_commands = ["plan", "destroy"]
}

dependency "project" {
  config_path = "${get_parent_terragrunt_dir()}/tech/dev/global/_project/"
  mock_outputs = {
    project_id = "invalid"
  }
  mock_outputs_allowed_terraform_commands = ["plan", "destroy"]
}

dependency "docker_project" {
  config_path = "${get_parent_terragrunt_dir()}/tech/shared/docker-registry/_project"
  mock_outputs = {
    project_id = "invalid"
  }
  mock_outputs_allowed_terraform_commands = ["plan", "destroy"]
}

dependency "pub_sub_topic" {
  config_path = "${get_parent_terragrunt_dir()}/tech/dev/global/pub-sub/topic-cluster-upgrade"
  mock_outputs = {
    id = "invalid"
  }
  mock_outputs_allowed_terraform_commands = ["plan", "destroy"]
}

inputs = {
  location                         = "europe-west1"
  team                             = "infra-and-ops"
  project                          = dependency.project.outputs.project_id
  docker_project                   = dependency.docker_project.outputs.project_id
  network                          = dependency.vpc.outputs.network
  private_network                  = dependency.vpc.outputs.private
  public_subnetwork                = dependency.vpc.outputs.public_subnetwork
  cluster_secondary_ip_range_name  = dependency.vpc.outputs.gke_cluster_secondary_ip_range_name
  services_secondary_ip_range_name = dependency.vpc.outputs.gke_services_secondary_ip_range_name
  pubsub_notification_topic        = dependency.pub_sub_topic.outputs.id

  node_pools = {
    "default-pool" = {
      labels = {
        "type" = "default"
      }
      spot = true
    }
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

    provider "google-beta" {
      project = "${dependency.project.outputs.project_id}"
      region  = "europe-west1"
    }
    EOF
}
