variable "name" {
  type = string
}

variable "location" {
  type    = string
  default = "EU"
}

variable "force_destroy" {
  type    = bool
  default = "false"
}
