variable "name" {
  type = string
}

variable "combiner" {
  type = string
}

variable "enabled" {
  type    = bool
  default = true
}

variable "custom_metric_descriptions" {
  type    = list(string)
  default = []
}

variable "notification_channels" {
  type = list(string)
}

variable "documentation" {
  type = object({
    content = string
  })
  default = {
    content = "No description."
  }
}

variable "conditions" {
  type = list(object({
    display_name = string
    condition_threshold = object({
      filter          = string
      duration        = string
      comparison      = string
      threshold_value = optional(string)
      trigger = optional(object({
        count = optional(string)
      }))
      aggregations = object({
        alignment_period     = string
        per_series_aligner   = string
        cross_series_reducer = optional(string)
        group_by_fields      = optional(list(string))
      })
    })
  }))
}

variable "user_labels" {
  type    = map(string)
  default = {}
}

variable "metric_name" {
  type    = string
  default = null
}

variable "metric_filter" {
  type    = string
  default = null
}
