variable "name" {
  type = string
}

variable "namespace" {
  type    = string
  default = "default"
}

variable "secret_name" {
  type    = string
  default = ""
}

variable "labels" {
  type = map(string)
}

variable "roles" {
  type = list(string)
}
