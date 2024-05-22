variable "name" {
  type = string
}

variable "managed_zone" {
  type        = string
  description = "The name of the managed zone, ex: google_dns_managed_zone.my-zone.name"
}

variable "rrdatas" {
  type = list(string)
}

variable "type" {
  type    = string
  default = "A"
}

variable "ttl" {
  type    = number
  default = 300
}