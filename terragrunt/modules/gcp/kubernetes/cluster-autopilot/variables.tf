variable "name" {
  description = "The name of the cluster"
  type        = string
}

variable "description" {
  description = "The description of the cluster"
  type        = string
  default     = ""
}

variable "location" {
  description = "The location (region or zone) to host the cluster in"
  type        = string
}
