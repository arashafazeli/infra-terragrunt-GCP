variable "boot_disk_image" {
  type    = string
  default = "debian-cloud/debian-9"
}

variable "machine_type" {
  type = string
}

variable "name" {
  type = string
}

variable "zone" {
  type    = string
  default = "europe-west1-b"
}

variable "network" {
  type    = string
  default = "default"
}

variable "subnetwork" {
  type    = string
  default = "default"
}

variable "tags" {
  type    = list(string)
  default = []
}

variable "service_account_email" {
  type    = string
  default = null
}

variable "service_account_scopes" {
  type    = set(string)
  default = []
}

variable "allow_stopping_for_update" {
  type    = bool
  default = false
}

variable "desired_status" {
  type    = string
  default = "RUNNING"
}
