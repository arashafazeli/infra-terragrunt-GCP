variable "name" {
  type = string
}

variable "description" {
  type    = string
  default = null
}

variable "network" {
  type = string
}

variable "direction" {
  type    = string
  default = "INGRESS"
}

variable "disabled" {
  type    = bool
  default = false
}

variable "source_ranges" {
  type    = list(string)
  default = null
}

variable "destination_ranges" {
  type    = list(string)
  default = null
}

variable "priority" {
  type    = number
  default = 1000
}

variable "allow" {
  type = list(object({
    protocol = string
    ports    = list(string)
    })
  )
  default = []
}

variable "deny" {
  type = list(object({
    protocol = string
    ports    = list(string)
    })
  )
  default = []
}