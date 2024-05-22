output "id" {
  description = "Id of the network"
  value       = google_compute_network.vpc.id
}

output "name" {
  description = "Name of the network"
  value       = google_compute_network.vpc.name
}

output "network" {
  description = "A reference (self_link) to the VPC network"
  value       = google_compute_network.vpc.self_link
}

# ---------------------------------------------------------------------------------------------------------------------
# Public Subnetwork Outputs
# ---------------------------------------------------------------------------------------------------------------------

output "public_subnetwork" {
  description = "A reference (self_link) to the public subnetwork"
  value       = google_compute_subnetwork.vpc_subnetwork_public.self_link
}

output "public_subnetwork_name" {
  description = "Name of the public subnetwork"
  value       = google_compute_subnetwork.vpc_subnetwork_public.name
}

output "public_subnetwork_cidr_block" {
  value = google_compute_subnetwork.vpc_subnetwork_public.ip_cidr_range
}

output "public_subnetwork_gateway" {
  value = google_compute_subnetwork.vpc_subnetwork_public.gateway_address
}
output "gke_cluster_secondary_ip_range_name" {
  value = var.gke_cluster_secondary_ip_range_name
}

output "gke_services_secondary_ip_range_name" {
  value = var.gke_services_secondary_ip_range_name
}

# ---------------------------------------------------------------------------------------------------------------------
# Access Tier - Network Tags
# ---------------------------------------------------------------------------------------------------------------------

output "public" {
  description = "The network tag string used for the public access tier"
  value       = module.network_firewall.public
}

output "public_restricted" {
  description = "The string of the public tag"
  value       = module.network_firewall.public_restricted
}

output "private" {
  description = "The network tag string used for the private access tier"
  value       = module.network_firewall.private
}

output "private_persistence" {
  description = "The network tag string used for the private-persistence access tier"
  value       = module.network_firewall.private_persistence
}
