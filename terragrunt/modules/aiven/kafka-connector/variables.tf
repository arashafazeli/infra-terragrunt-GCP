variable "service_name" {
  type = string
}

variable "project_name" {
  type = string
}

variable "connector_name" {
  type = string
}

variable "config" {
  type      = map(string)
  sensitive = true
}
