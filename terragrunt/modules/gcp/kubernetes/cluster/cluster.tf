# ---------------------------------------------------------------------------------------------------------------------
# DEPLOY A PRIVATE CLUSTER IN GOOGLE CLOUD PLATFORM
# ---------------------------------------------------------------------------------------------------------------------
locals {
  # Some logic to handle env variable for both old dev, prod and new tech-folder
  env = length(regexall("/live/tech/(.*?)/", abspath(path.root))) > 0 ? regex("/live/tech/(.*?)/", abspath(path.root))[0] : regex("/live/(.*?)/", abspath(path.root))[0]
  labels = {
    kubernetes_label_env  = local.env
    kubernetes_label_team = var.team
  }
}

module "gke_cluster" {
  source = "./gke-cluster"

  name = var.cluster_name

  location = var.location
  network  = var.network

  master_ipv4_cidr_block = var.master_ipv4_cidr_block

  # We're deploying the cluster in the 'public' subnetwork to allow outbound internet access
  # See the network access tier table for full details:
  # https://github.com/gruntwork-io/terraform-google-network/tree/master/modules/vpc-network#access-tier
  subnetwork                       = var.public_subnetwork
  cluster_secondary_ip_range_name  = var.cluster_secondary_ip_range_name
  services_secondary_ip_range_name = var.services_secondary_ip_range_name

  enable_private_nodes = true

  disable_public_endpoint = false
  master_authorized_networks_config = [
    {
      cidr_blocks = [
        {
          cidr_block   = "0.0.0.0/0"
          display_name = "allow-from-anywhere"
        },
      ]
    },
  ]

  pubsub_notification_topic = var.pubsub_notification_topic

  alternative_default_service_account = module.gke_service_account.email
  resource_labels                     = local.labels

  autoscaling_profile = var.autoscaling_profile
}

# ---------------------------------------------------------------------------------------------------------------------
# CREATE NODE POOLS
# ---------------------------------------------------------------------------------------------------------------------

locals {
  pools = {
    for role, conf in var.node_pools :
    role => merge(var.node_pool_default_config, conf)
  }
}

resource "random_id" "name" {
  byte_length = 2
}

resource "google_container_node_pool" "node_pool" {
  for_each = local.pools
  name     = "${each.key}-${random_id.name.hex}"

  provider = google-beta
  location = var.location
  cluster  = module.gke_cluster.name

  initial_node_count = each.value.initial_node_count

  autoscaling {
    min_node_count = each.value.min_node_count
    max_node_count = each.value.max_node_count
  }

  management {
    auto_repair  = each.value.auto_repair
    auto_upgrade = each.value.auto_upgrade
  }

  node_config {
    image_type   = each.value.image_type
    machine_type = each.value.machine_type
    disk_size_gb = each.value.disk_size_gb
    disk_type    = each.value.disk_type
    preemptible  = each.value.preemtible
    spot         = each.value.spot

    tags = [
      var.private_network
    ]
    service_account = module.gke_service_account.email
    labels          = each.value.labels
    oauth_scopes    = each.value.oauth_scopes

    # Enable workload identity
    workload_metadata_config {
      mode = "GKE_METADATA"
    }
  }

  lifecycle {
    ignore_changes = [
      initial_node_count
    ]
  }

  timeouts {
    create = "90m"
    update = "90m"
    delete = "90m"
  }
  upgrade_settings {
    max_surge       = 1
    max_unavailable = 0
  }
}

# ---------------------------------------------------------------------------------------------------------------------
# CREATE A CUSTOM SERVICE ACCOUNT TO USE WITH THE GKE CLUSTER
# ---------------------------------------------------------------------------------------------------------------------

module "gke_service_account" {
  # When using these modules in your own templates, you will need to use a Git URL with a ref attribute that pins you
  # to a specific version of the modules, such as the following example:
  source = "./gke-service-account"

  name        = var.cluster_service_account_name
  description = var.cluster_service_account_description
  service_account_roles = [
    "roles/cloudsql.editor"
  ]
}

# Allow service account to pull images from GCR
resource "google_project_iam_member" "project" {
  project = var.docker_project
  role    = "roles/storage.objectViewer"
  member  = "serviceAccount:${module.gke_service_account.email}"
}
