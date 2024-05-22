output "name" {
  value = module.gke_cluster.name
}

output "endpoint" {
  value     = module.gke_cluster.endpoint
  sensitive = true
}

output "ca_certificate" {
  value = module.gke_cluster.cluster_ca_certificate
}