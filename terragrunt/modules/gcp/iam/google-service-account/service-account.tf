data "google_client_config" "get_project" {}

resource "google_service_account" "service_account" {
  project    = data.google_client_config.get_project.project
  account_id = var.name
  lifecycle {
    create_before_destroy = false
  }
}

resource "google_project_iam_member" "iam_member" {
  project  = data.google_client_config.get_project.project
  for_each = toset(var.roles)
  role     = each.key
  member   = "serviceAccount:${google_service_account.service_account.email}"
}

resource "google_service_account_key" "service_account_key" {
  service_account_id = google_service_account.service_account.name
}

resource "kubernetes_secret" "google-application-credentials" {
  metadata {
    name      = coalesce(var.secret_name, "${var.name}-account-secret")
    namespace = var.namespace
    labels    = var.labels
  }
  data = {
    "credentials.json" = base64decode(google_service_account_key.service_account_key.private_key)
  }
}
