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

variable "kafka_version" {
  type    = string
  default = "3.5"
}

variable "termination_protection" {
  type    = bool
  default = true
}

variable "kafka_connect" {
  type    = bool
  default = true
}
