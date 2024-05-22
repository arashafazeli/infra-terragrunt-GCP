variable "timeout" {
  type    = string
  default = "10s"
}

variable "paths" {
  type = list(string)
}

variable "host" {
  type = string
}

variable "notification_channels" {
  type = list(string)
}
