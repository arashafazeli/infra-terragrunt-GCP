variable "location" {
  type    = string
  default = "europe-west1"
}

variable "name" {
  type    = string
  default = ""
}

variable "description" {
  type    = string
  default = "artifact registry for docker images"
}

variable "format" {
  type    = string
  default = "DOCKER"

}

variable "project" {
  type    = string
  default = "docker-registry-shared-cc74"
}

variable "random_id_length" {
  type    = number
  default = 3
}

variable "member" {
  type    = string
  default = "allAuthenticatedUsers"
}
