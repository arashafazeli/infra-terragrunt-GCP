variable "name" {
  type = string
}

variable "dns_name" {
  type = string
}

variable "dns_project" {
  type = string
}

variable "dns_domain" {
  type = string
}

variable "team" {
  type = string
}

variable "product" {
  type = string
}

variable "main_page_suffix" {
  type    = string
  default = "index.html"
}

variable "not_found_page" {
  type    = string
  default = "404.html"
}

variable "role_entity" {
  description = "Sets bucket default object ACLs to allow all users read access to objects"
  type        = list(string)
  default     = ["READER:allUsers"]
}

variable "github_repository_name" {
  type    = string
  default = ""
}