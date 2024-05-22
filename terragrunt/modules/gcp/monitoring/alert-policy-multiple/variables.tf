variable "alert_policies" {
  type = map(any)
}

variable "user_labels" {
  type    = map(any)
  default = {}
}
