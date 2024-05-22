
variable "name" {
  type = string
}

variable "roles" {
  type    = set(string)
  default = ["USER"]
}

variable "refresh_tokens" {
  type = map(list(string))
  default = {
    core = ["SUPER_USER"]
  }
}
