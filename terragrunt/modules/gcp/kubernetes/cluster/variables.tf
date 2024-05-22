variable "location" {
  type = string
}

variable "docker_project" {
  type = string
}

variable "team" {
  type = string
}

variable "network" {
  type = string
}

variable "private_network" {
  type = string
}

variable "public_subnetwork" {
  type = string
}

variable "cluster_secondary_ip_range_name" {
  description = "The name of the secondary range within the subnetwork for the cluster to use"
  type        = string
}

variable "services_secondary_ip_range_name" {
  description = "The name of the secondary range within the subnetwork for the services to use"
  type        = string
}

variable "cluster_name" {
  description = "The name of the Kubernetes cluster."
  type        = string
  default     = "gloot-cluster"
}

variable "cluster_service_account_name" {
  description = "The name of the custom service account used for the GKE cluster. This parameter is limited to a maximum of 28 characters."
  type        = string
  default     = "gloot-cluster-sa"
}

variable "cluster_service_account_description" {
  description = "A description of the custom service account used for the GKE cluster."
  type        = string
  default     = "GKE Cluster Service Account managed by Terraform"
}

# Kubectl options
variable "master_ipv4_cidr_block" {
  description = "The IP range in CIDR notation (size must be /28) to use for the hosted master network. This range will be used for assigning internal IP addresses to the master or set of masters, as well as the ILB VIP. This range must not overlap with any other ranges in use within the cluster's network."
  type        = string
  default     = "10.6.0.0/28"
}

# Node Pool Configuration
variable "node_pool_default_config" {
  type        = any
  description = "Default config for Node Pool. Can be overriden with node_pool_config variable."
  default = {
    initial_node_count = 1
    min_node_count     = 1
    max_node_count     = 30
    auto_repair        = "true"
    auto_upgrade       = "true"
    machine_type       = "n1-standard-4"
    image_type         = "COS_CONTAINERD"
    preemtible         = false
    spot               = false
    disk_size_gb       = "30"
    disk_type          = "pd-standard"
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform",
      "https://www.googleapis.com/auth/devstorage.read_only"
    ]
    labels = {}
    taint  = []
  }
}

variable "node_pools" {
  type = any
  default = {
    "main-pool-1" = {}
  }
}

variable "pubsub_notification_topic" {
  description = "The pub/sub topic to be used for cluster upgrade notifications."
  type        = string
  default     = ""
}

variable "autoscaling_profile" {
  description = "Autoscaling profile for node pools. BALANCE AND OPTIMIZE_UTILIZATION (beta) is available."
  type        = string
  default     = "BALANCED"
}
