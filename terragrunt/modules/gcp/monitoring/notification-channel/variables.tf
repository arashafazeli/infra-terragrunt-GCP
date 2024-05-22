variable "name" {
  type = string
}

variable "type" {
  type = string
}

variable "enabled" {
  type    = bool
  default = true
}

variable "labels" {
  type      = map(string)
  sensitive = true
  default   = {}
}
