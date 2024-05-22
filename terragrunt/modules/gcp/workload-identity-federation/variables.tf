variable "project_id" {
  description = "GCP project ID"
  type        = string
}

variable "name" {
  description = "Service account name. Required if using existing KSA."
  type        = string
  default     = ""
}

variable "pool_id" {
  description = "pool_id name. Required  for making pool workload."
  type        = string
  default     = ""
}
variable "provider_id" {
  description = "provider_id name. Required if using pool id"
  type        = string
  default     = ""
}

variable "attribute" {
  description = "attribute to grant service account access to resources. "
  type        = string
  default     = ""
}

