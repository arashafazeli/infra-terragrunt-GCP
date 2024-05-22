output "name" {
  value = aiven_kafka.kafka.service_name
}

output "access_cert" {
  value     = aiven_kafka_user.user.access_cert
  sensitive = true
}

output "access_key" {
  value     = aiven_kafka_user.user.access_key
  sensitive = true
}

output "uri" {
  value     = aiven_kafka.kafka.service_uri
  sensitive = true
}
