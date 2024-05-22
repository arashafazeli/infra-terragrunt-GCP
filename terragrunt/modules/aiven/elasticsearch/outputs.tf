output "name" {
  value = aiven_elasticsearch.elasticsearch.service_name
}

output "host" {
  value = aiven_elasticsearch.elasticsearch.service_host
}

output "port" {
  value = aiven_elasticsearch.elasticsearch.service_port
}

output "username" {
  value = aiven_elasticsearch.elasticsearch.service_username
}

output "password" {
  value     = aiven_elasticsearch.elasticsearch.service_password
  sensitive = true
}

output "uri" {
  value     = aiven_elasticsearch.elasticsearch.service_uri
  sensitive = true
}
