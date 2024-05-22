output "name" {
  value = google_dns_managed_zone.dns_zone.name
}

output "dns_name" {
  value = trimsuffix(var.dns_name, ".")
}

output "project" {
  value = google_dns_managed_zone.dns_zone.project
}

output "nameservers" {
  value = google_dns_managed_zone.dns_zone.name_servers
}