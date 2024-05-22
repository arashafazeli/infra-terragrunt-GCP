locals {
  name_prefix = "private-vpc-${random_string.suffix.result}"
}

# Use a random suffix to prevent overlap in network names
resource "random_string" "suffix" {
  length  = 4
  special = false
  upper   = false
}

# ---------------------------------------------------------------------------------------------------------------------
# Create the Network & corresponding Router to attach other resources to
# Networks that preserve the default route are automatically enabled for Private Google Access to GCP services
# provided subnetworks each opt-in; in general, Private Google Access should be the default.
# ---------------------------------------------------------------------------------------------------------------------

resource "google_compute_network" "vpc" {
  name = "${local.name_prefix}-network"

  # Always define custom subnetworks- one subnetwork per region isn't useful for an opinionated setup
  auto_create_subnetworks = "false"

  # A global routing mode can have an unexpected impact on load balancers; always use a regional mode
  routing_mode = "REGIONAL"
}

resource "google_compute_router" "vpc_router" {
  name    = "${local.name_prefix}-router"
  network = google_compute_network.vpc.self_link
}

# ---------------------------------------------------------------------------------------------------------------------
# Public Subnetwork Config
# Public internet access for instances with addresses is automatically configured by the default gateway for 0.0.0.0/0
# External access is configured with Cloud NAT, which subsumes egress traffic for instances without external addresses
# ---------------------------------------------------------------------------------------------------------------------

resource "google_compute_subnetwork" "vpc_subnetwork_public" {
  name = "${local.name_prefix}-subnetwork-public"

  network = google_compute_network.vpc.self_link

  private_ip_google_access = true
  ip_cidr_range            = var.cidr_block

  dynamic "secondary_ip_range" {
    for_each = var.secondary_ip_ranges
    content {
      range_name    = secondary_ip_range.key
      ip_cidr_range = secondary_ip_range.value
    }
  }
}

resource "google_compute_router_nat" "vpc_nat" {
  name = "${local.name_prefix}-nat"

  router = google_compute_router.vpc_router.name

  nat_ip_allocate_option = "AUTO_ONLY"

  enable_endpoint_independent_mapping = false

  # "Manually" define the subnetworks for which the NAT is used, so that we can exclude the public subnetwork
  source_subnetwork_ip_ranges_to_nat = "LIST_OF_SUBNETWORKS"

  subnetwork {
    name                    = google_compute_subnetwork.vpc_subnetwork_public.self_link
    source_ip_ranges_to_nat = ["ALL_IP_RANGES"]
  }
}

# ---------------------------------------------------------------------------------------------------------------------
# Attach Firewall Rules to allow inbound traffic to tagged instances
# ---------------------------------------------------------------------------------------------------------------------

module "network_firewall" {
  source = "./network-firewall"

  name_prefix = local.name_prefix

  network                               = google_compute_network.vpc.self_link
  allowed_public_restricted_subnetworks = var.allowed_public_restricted_subnetworks

  source_ranges = concat([var.cidr_block], values(var.secondary_ip_ranges))

  allow_all_inbound = var.allow_all_inbound
}

# ---------------------------------------------------------------------------------------------------------------------
# VPC Peering range
# ---------------------------------------------------------------------------------------------------------------------

resource "google_compute_global_address" "peering_range" {
  provider = google-beta

  name          = "peering-range"
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  prefix_length = 16
  network       = google_compute_network.vpc.id
}

resource "google_service_networking_connection" "peering_range" {
  provider = google-beta

  network                 = google_compute_network.vpc.id
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.peering_range.name]
}
