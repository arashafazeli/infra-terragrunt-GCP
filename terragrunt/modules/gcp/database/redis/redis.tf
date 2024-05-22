resource "google_redis_instance" "cache" {
  name               = var.name
  tier               = var.tier
  memory_size_gb     = var.memory_size_gb
  replica_count      = var.replica_count
  read_replicas_mode = var.read_replicas_mode
  authorized_network = var.authorized_network
}
