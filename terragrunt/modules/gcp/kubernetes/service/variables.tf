variable "cluster_name" {
  type = string
}

variable "cluster_namespace" {
  type    = string
  default = "default"
}

variable "team" {
  type = string
}

variable "product" {
  type = string
}

variable "service_name" {
  type = string
}

variable "db_user_name" {
  type    = string
  default = ""
}

variable "db_instance_type" {
  type    = string
  default = ""
}

variable "db_name" {
  type    = string
  default = ""
}

variable "deletion_protection" {
  type    = bool
  default = true
}

variable "postgres_version" {
  type    = string
  default = "POSTGRES_13"
}

variable "activation_policy" {
  type    = string
  default = "ALWAYS"
}

variable "db_enable_failover_replica" {
  description = "Set to true to enable failover replica."
  type        = bool
  default     = true
}

variable "database_flags" {
  type = list(any)
  default = [
    {
      name  = "autovacuum_naptime"
      value = "2"
    },
  ]
}

variable "google_roles" {
  type    = list(string)
  default = ["roles/cloudsql.client", "roles/cloudprofiler.agent"]
}

variable "gloot_roles" {
  type    = list(string)
  default = []
}

variable "gloot_refresh_tokens" {
  type = map(list(string))
  default = {
    core = ["SUPER_USER"]
  }
}

variable "network" {
  description = "The resource link for the VPC network from which the Cloud SQL instance is accessible for private IP."
  type        = string
  default     = null
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

