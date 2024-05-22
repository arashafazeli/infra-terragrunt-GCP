resource "google_service_account" "preexisting" {
  account_id = var.name
}

module "my-app-workload-identity" {
  source              = "../workload-identity-base"
  use_existing_gcp_sa = true
  name                = google_service_account.preexisting.account_id
  project_id          = var.project_id
  namespace           = var.namespace
  # wait for the custom GSA to be created to force module data source read during apply
  # https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/issues/1059
  depends_on = [google_service_account.preexisting]
}
