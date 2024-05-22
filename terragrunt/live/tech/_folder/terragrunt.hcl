include {
  path = find_in_parent_folders()
}

terraform {
  source = "${get_parent_terragrunt_dir()}/..//modules/gcp/folder/"
}

prevent_destroy = true

inputs = {
  name   = "tech"
  parent = "organizations/649825086850"
  iam_bindings = {
    "roles/owner"                        = ["group:operations-admins@gloot.com", "serviceAccount:terraform-1@gloot-automation.iam.gserviceaccount.com"]
    "roles/container.admin"              = ["serviceAccount:gitlab-ci@gloot-automation.iam.gserviceaccount.com"]
    "roles/viewer"                       = ["group:tech@gloot.com", "group:insights@gloot.com"]
    "roles/resourcemanager.folderViewer" = ["group:tech@gloot.com", "group:insights@gloot.com"]
  }
}

generate "providers" {
  path      = "providers.tf"
  if_exists = "overwrite"
  contents  = <<-EOF
    data "google_client_config" "current" {}

    provider "google" {
      project = "gloot-automation"
      region  = "europe-west1"
    }
    EOF
}
