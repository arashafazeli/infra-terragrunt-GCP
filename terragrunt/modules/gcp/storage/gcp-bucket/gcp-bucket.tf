module "bucket" {
  source = "./main-bucket"

  name       = var.name
  project_id = var.project_id
  location   = var.location

  lifecycle_rules = var.lifecycle_rules

  iam_members = var.iam_members
}
