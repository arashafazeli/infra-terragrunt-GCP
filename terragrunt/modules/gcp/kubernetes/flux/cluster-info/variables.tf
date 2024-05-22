variable "labels" {
  type = object({
    env     = string,
    team    = string,
    app     = string,
    product = string,
  })
}

variable "namespace" {
  type    = string
  default = "core"
}

variable "project_id" {
  type = string
}

variable "region" {
  type = string
}

variable "cluster_name" {
  type = string
}

variable "dns_zone" {
  type = string
}
