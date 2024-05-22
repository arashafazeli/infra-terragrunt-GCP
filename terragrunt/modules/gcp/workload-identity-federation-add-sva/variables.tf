variable "project_id" {
  description = "GCP project ID"
  type        = string
}

variable "name1" {
  type        = string
  description = "Service Account resource names and corresponding provider attributes"
  default     = ""
}

variable "name2" {
  type        = string
  description = "Service Account resource names and corresponding provider attributes"
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
