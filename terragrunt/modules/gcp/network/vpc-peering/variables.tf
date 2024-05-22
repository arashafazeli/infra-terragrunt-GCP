variable "name" {
  type = string
}

variable "network_id" {
  type = string
}

variable "peer_network_id" {
  type = string
}

variable "import_custom_routes" {
  type    = bool
  default = false
}

variable "export_custom_routes" {
  type    = bool
  default = false
}