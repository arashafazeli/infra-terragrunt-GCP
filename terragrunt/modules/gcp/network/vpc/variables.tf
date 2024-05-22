# ---------------------------------------------------------------------------------------------------------------------
# OPTIONAL PARAMETERS
# ---------------------------------------------------------------------------------------------------------------------

variable "cidr_block" {
  description = "The IP address range of the VPC in CIDR notation. A prefix of /16 is recommended. Do not use a prefix higher than /27."
  default     = "10.0.0.0/16"
  type        = string
}

variable "secondary_ip_ranges" {
  description = "VPC secondary address range in CIDR notation. A prefix of /16 is recommended. Do not use a prefix higher than /27."
  type        = map(string)
  default     = {}
}

variable "allowed_public_restricted_subnetworks" {
  description = "The public networks that is allowed access to the public_restricted subnetwork of the network"
  default     = []
  type        = list(string)
}

variable "gke_cluster_secondary_ip_range_name" {
  description = "The name for cluster secondary ip range"
  type        = string
  default     = ""
}

variable "gke_services_secondary_ip_range_name" {
  description = "The name for services secondary ip range"
  type        = string
  default     = ""
}

variable "allow_all_inbound" {
  description = "Allow all inbound traffic to network"
  type        = bool
  default     = true
}
