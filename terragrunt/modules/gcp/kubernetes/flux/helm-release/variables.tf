variable "default_release_config" {
  type = any
  default = {
    repository  = "https://kubernetes-charts.storage.googleapis.com"
    atomic      = true
    max_history = 2
    value_files = []
    namespace   = "default"
  }
}

variable "release_config" {
  type    = any
  default = {}
}

variable "sets" {
  type = map(any)
}

