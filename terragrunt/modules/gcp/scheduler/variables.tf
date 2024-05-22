variable "name" {
  type = string
}

variable "description" {
  type = string
}

variable "topic_name" {
  type    = string
  default = ""
}

variable "http_uri" {
  type    = string
  default = ""
}

variable "http_method" {
  type    = string
  default = "GET"
}

variable "schedule" {
  type = string
}

variable "message" {
  type    = string
  default = ""
}
