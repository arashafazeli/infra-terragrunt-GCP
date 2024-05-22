variable "name" {
  type = string
}

variable "team" {
  type = string
}

variable "folder" {
  type    = string
  default = ""
}

variable "organization_id" {
  type    = string
  default = "649825086850"
}

variable "billing_account" {
  type    = string
  default = "001F32-B68B72-F22935"
}

variable "services" {
  type = set(string)
  default = [
    "iam.googleapis.com",
    "sql-component.googleapis.com",
    "sqladmin.googleapis.com",
    "servicenetworking.googleapis.com",
    "storage-api.googleapis.com",
    "cloudbilling.googleapis.com",
    "compute.googleapis.com",
    "container.googleapis.com",
    "logging.googleapis.com",
    "cloudprofiler.googleapis.com",
    "stackdriver.googleapis.com",
    "dns.googleapis.com",
    "containerregistry.googleapis.com",
    "cloudbuild.googleapis.com",
    "cloudresourcemanager.googleapis.com",
    "cloudfunctions.googleapis.com",
    "cloudkms.googleapis.com",
    "cloudscheduler.googleapis.com",
  ]
}

variable "iam_bindings" {
  type    = map(any)
  default = {}
}

variable "create_container_registry" {
  type    = bool
  default = false
}

variable "random_id_length" {
  type    = number
  default = 2
}

variable "create_app_engine_application" {
  type    = bool
  default = false
}
