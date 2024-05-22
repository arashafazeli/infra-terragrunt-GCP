variable "names" {
  type = list(string)
}

variable "roles" {
  type = list(list(string))
}

variable "project_id" {
  description = "The ID of the project in which to provision resources."
  type        = string
}