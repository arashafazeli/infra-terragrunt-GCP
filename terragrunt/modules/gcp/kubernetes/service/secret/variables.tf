variable "name" {
  type = string
}

variable "data" {
  type = map(string)
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
  type    = string
  default = "default"
}

variable "type" {
  type    = string
  default = "Opaque"
}