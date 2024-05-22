variable "service_name" {
  type    = string
  default = "bi-pipeline"
}

variable "team" {
  type = string
}

variable "product" {
  type = string
}

variable "cluster_name" {
  type = string
}

variable "cluster_namespace" {
  type    = string
  default = "default"
}

variable "dataset_name" {
  type = string
}

variable "dataset_id" {
  type = string
}

variable "tables" {
  type = map(string)
}
