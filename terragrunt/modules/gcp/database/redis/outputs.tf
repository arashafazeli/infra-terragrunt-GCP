output "redis_host" {
  value = google_redis_instance.cache.host
}

output "redis_port" {
  value = google_redis_instance.cache.port
}

output "redis_read_endpoint" {
  value = google_redis_instance.cache.read_endpoint
}

output "redis_read_endpoint_port" {
  value = google_redis_instance.cache.read_endpoint_port
}
