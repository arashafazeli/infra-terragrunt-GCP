variable "secret_name" {
  type = string
}

variable "service_name" {
  type = string
}

variable "team" {
  type = string
}

variable "product" {
  type = string
}

variable "namespace" {
  type    = list(string)
  default = ["default"]
}

