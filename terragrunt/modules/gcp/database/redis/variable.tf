variable "tier" {
  type    = string
  default = "STANDARD_HA"
}

variable "name" {
  type = string
}

variable "memory_size_gb" {
  type    = number
  default = 5
}

variable "replica_count" {
  type    = number
  default = 2
}

variable "read_replicas_mode" {
  type    = string
  default = "READ_REPLICAS_DISABLED"
}
variable "authorized_network" {
  type = string
}
