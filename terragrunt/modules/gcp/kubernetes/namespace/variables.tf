variable "cluster_name" {
  type = string
}

variable "team" {
  type = string
}

variable "product" {
  type = string
}

variable "default_namespace_config" {
  type = any
  default = {
    name        = "default"
    annotations = {}
  }
}

variable "namespace_config" {
  type    = any
  default = {}
}