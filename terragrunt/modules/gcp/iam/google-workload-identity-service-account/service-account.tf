data "google_client_config" "get_project" {}

/* Create google service account */
resource "google_service_account" "service_account" {
  account_id = var.name

  lifecycle {
    create_before_destroy = false
  }
}
/* Give google service account roles */
resource "google_project_iam_member" "iam_member" {
  for_each = toset(var.roles)
  role     = each.key
  project  = data.google_client_config.get_project.project
  member   = "serviceAccount:${google_service_account.service_account.email}"
}
/* Bind kubernetes service account to google service account */
resource "google_service_account_iam_binding" "workload_identity" {
  service_account_id = "projects/${data.google_client_config.get_project.project}/serviceAccounts/${google_service_account.service_account.email}"
  role               = "roles/iam.workloadIdentityUser"
  members = [
    "serviceAccount:${data.google_client_config.get_project.project}.svc.id.goog[${var.namespace}/${var.kubernetes_sa_name}]"
  ]
}
