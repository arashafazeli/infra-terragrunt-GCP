variable "service_name" {
  type = string
}

variable "team" {
  type = string
}

variable "product" {
  type = string
}

variable "cluster_name" {
  type = string
}

variable "cluster_namespace" {
  type    = string
  default = "default"
}

variable "api_gateway_name" {
  type    = string
  default = "api-gateway"
}