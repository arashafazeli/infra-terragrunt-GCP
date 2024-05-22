variable "name" {
  type = string
}

variable "kubernetes_sa_name" {
  type = string
}

variable "namespace" {
  type    = string
  default = "default"
}

variable "roles" {
  type = list(string)
}
