variable "github_base_url" {
  type    = string
  default = "https://api.github.com/"
}

variable "github_org_name" {
  type    = string
  default = "g-loot"
}

variable "github_repository_name" {
  type = string
}

variable "gloot_refresh_tokens" {
  type = map(list(string))
}

variable "gloot_roles" {
  type    = set(string)
  default = ["USER"]
}
