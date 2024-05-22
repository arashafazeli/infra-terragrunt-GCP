variable "plan" {
  type = string
}

variable "service_name" {
  type = string
}

variable "source_service_name" {
  type = string
}

variable "project_name" {
  type = string
}

variable "project_vpc_id" {
  type = string
}

variable "termination_protection" {
  type    = bool
  default = true
}
