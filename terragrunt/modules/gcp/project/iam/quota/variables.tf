variable "service" {
  description = "Service name"
  type        = string
}

variable "metric" {
  description = "Metric name"
  type        = string
}

variable "limit" {
  description = "Required limit"
  type        = string
}

variable "override_value" {
  description = "Override value"
  type        = string
}

variable "dimensions" {
  description = "Dimensions"
  type        = map(string)
  default     = {}
}

variable "project" {
  description = "Project id"
  type        = string
  default     = ""
}

variable "force" {
  description = "If the new quota would decrease the existing quota by more than 10%, the request is rejected. If force is true, that safety check is ignored."
  type        = bool
  default     = false
}
