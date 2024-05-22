variable "name_prefix" {
  type = string
}

variable "user_name" {
  type = string
}

variable "machine_type" {
  type = string
}

variable "db_name" {
  type    = string
  default = "eventsdb"
}

variable "activation_policy" {
  type    = string
  default = "ALWAYS"
}

variable "postgres_version" {
  type    = string
  default = "POSTGRES_11"
}

variable "deletion_protection" {
  type    = bool
  default = true
}

variable "deletion_policy" {
  type    = string
  default = "ABANDON"
}

variable "num_read_replicas" {
  type    = number
  default = 0
}

variable "read_replica_zones" {
  type    = list(string)
  default = []
}

variable "zone" {
  type    = string
  default = "europe-west1-d"
}

variable "network" {
  description = "The resource link for the VPC network from which the Cloud SQL instance is accessible for private IP."
  type        = string
}

variable "database_flags" {
  type = list(any)
}

variable "labels" {
  type = map(string)
}

variable "db_enable_failover_replica" {
  description = "Set to true to enable failover replica."
  type        = bool
  default     = true
}

variable "db_insights_enabled" {
  type    = bool
  default = false
}

variable "db_insights_query_string_length" {
  type    = number
  default = 1024
}

variable "db_insights_record_application_tags" {
  type    = bool
  default = false
}

variable "db_insights_record_client_address" {
  type    = bool
  default = false
}
