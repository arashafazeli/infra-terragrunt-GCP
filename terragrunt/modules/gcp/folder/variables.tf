variable "name" {
  type = string
}

variable "parent" {
  type = string
}

variable "iam_bindings" {
  type    = map(any)
  default = {}
}