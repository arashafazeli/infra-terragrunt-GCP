variable "name" {
  type = string
}

variable "location" {
  type    = string
  default = "global"
}

variable "rotation_period" {
  type    = string
  default = "100000s"
}
