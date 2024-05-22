variable "plan" {
  type = string
}

variable "service_name" {
  type = string
}

variable "project_name" {
  type = string
}

variable "project_vpc_id" {
  type = string
}

variable "opensearch_version" {
  type    = string
  default = "1"
}

variable "termination_protection" {
  type    = bool
  default = true
}
