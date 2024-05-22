module "service_accounts" {
  source = "terraform-google-modules/service-accounts/google"

  project_id    = var.project_id
  prefix        = ""
  names         = var.names
  generate_keys = true
  display_name  = "Multiple Service Accounts"
  description   = "Add multiple roles to multiple Service Accounts"
  roles         = var.roles
}

