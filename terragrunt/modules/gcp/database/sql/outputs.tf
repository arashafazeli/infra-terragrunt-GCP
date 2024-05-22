output "password" {
  value     = random_password.password.result
  sensitive = true
}

output "master_proxy_connection" {
  value = module.postgres.master_proxy_connection
}

output "read_replica_proxy_connections" {
  value = module.postgres.read_replica_proxy_connections
}
