output "project_name" {
  value = aiven_project.project.project
}

output "ca_cert" {
  value     = aiven_project.project.ca_cert
  sensitive = true
}
