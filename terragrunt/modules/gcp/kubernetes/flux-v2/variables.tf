variable "target_path" {
  type = string
}

variable "branch" {
  type    = string
  default = "main"
}

variable "github_owner" {
  type    = string
  default = "g-loot"
}

variable "github_repository" {
  type    = string
  default = "infra-gitops"
}

variable "cluster_name" {
  type = string
}

variable "dns_zone" {
  type = string
}

variable "service_name" {
  type    = string
  default = "flux"
}

variable "team" {
  type    = string
  default = "infra-and-ops"
}

variable "product" {
  type    = string
  default = "core-service"
}
