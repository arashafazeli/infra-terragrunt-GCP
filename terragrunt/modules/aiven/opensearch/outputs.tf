output "name" {
  value = aiven_opensearch.opensearch.service_name
}

output "host" {
  value = aiven_opensearch.opensearch.service_host
}

output "port" {
  value = aiven_opensearch.opensearch.service_port
}

output "username" {
  value = aiven_opensearch.opensearch.service_username
}

output "password" {
  value     = aiven_opensearch.opensearch.service_password
  sensitive = true
}

output "uri" {
  value     = aiven_opensearch.opensearch.service_uri
  sensitive = true
}
