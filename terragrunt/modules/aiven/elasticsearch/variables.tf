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

variable "elasticsearch_version" {
  type    = string
  default = "7"
}

variable "termination_protection" {
  type    = bool
  default = true
}
