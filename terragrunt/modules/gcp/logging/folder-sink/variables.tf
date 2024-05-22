variable "name" {
  type = string
}

variable "description" {
  type    = string
  default = "Managed by Terraform"
}

variable "enabled" {
  type    = bool
  default = true
}

variable "folder" {
  type = string
}

variable "destination" {
  type = string
}

variable "filter" {
  type = string
}

variable "iam_binding" {
  type = object({
    project = string
    role    = string
  })
}
