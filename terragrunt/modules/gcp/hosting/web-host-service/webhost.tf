data "google_client_config" "current" {}

locals {
  # Some logic to handle env variable for both old dev, prod and new tech-folder
  env = length(regexall("/live/tech/(.*?)/", abspath(path.root))) > 0 ? regex("/live/tech/(.*?)/", abspath(path.root))[0] : regex("/live/(.*?)/", abspath(path.root))[0]
  labels = {
    kubernetes_label_app     = var.name
    kubernetes_label_env     = local.env
    kubernetes_label_product = var.product
    kubernetes_label_team    = var.team
  }
  hostname = format("%s.%s", var.name, var.dns_domain)
  name     = replace(local.hostname, ".", "-")
}

module "ip_address" {
  source = "./ip-address"
  name   = local.name
  labels = local.labels
}

module "dns_entry" {
  source       = "./dns-entry"
  name         = "${local.hostname}."
  managed_zone = var.dns_name
  rrdatas      = [module.ip_address.address]
}

resource "google_compute_global_forwarding_rule" "web-host-service" {
  provider   = google-beta
  name       = "${local.name}-port-443"
  ip_address = module.ip_address.address
  port_range = "443"
  target     = google_compute_target_https_proxy.web-host-service.self_link
  labels     = local.labels
}

resource "google_compute_target_https_proxy" "web-host-service" {
  name             = local.name
  url_map          = google_compute_url_map.web-host-service.self_link
  ssl_certificates = [google_compute_managed_ssl_certificate.web-host-service.self_link]
}

resource "google_compute_managed_ssl_certificate" "web-host-service" {
  provider = google-beta

  name = local.name

  managed {
    domains = [local.hostname]
  }
}

resource "google_compute_url_map" "web-host-service" {
  name            = local.name
  default_service = google_compute_backend_bucket.web-host-service.self_link
}

resource "google_compute_backend_bucket" "web-host-service" {
  name        = "${local.name}-backend-bucket"
  bucket_name = google_storage_bucket.web-host-service.name
  enable_cdn  = true
}

resource "google_storage_bucket" "web-host-service" {
  name     = local.name
  location = "EU"
  labels   = local.labels

  force_destroy = true

  website {
    main_page_suffix = var.main_page_suffix
    not_found_page   = var.not_found_page
  }
}

resource "google_storage_bucket_iam_binding" "web-host-service" {
  bucket = google_storage_bucket.web-host-service.name
  role   = "roles/storage.objectViewer"
  members = [
    "allUsers"
  ]
}

/* Allow github service account to flush cache */
resource "random_id" "name" {
  byte_length = 2
}

resource "google_project_iam_custom_role" "invalidate_cache" {
  role_id     = "invalidateCache${random_id.name.hex}"
  title       = "Invalidate cache for ${data.google_client_config.current.project}"
  description = "Custom role that allows invalidation of the cache for ${data.google_client_config.current.project} project"
  permissions = ["compute.urlMaps.invalidateCache"]
}

resource "google_project_iam_member" "github_invalidate_cache" {
  project = data.google_client_config.current.project
  role    = google_project_iam_custom_role.invalidate_cache.name
  member  = "serviceAccount:gitlab-ci@gloot-automation.iam.gserviceaccount.com"
}

/* Add secrets to GitHub, if repo is set */
resource "github_actions_secret" "bucket_name" {
  count           = var.github_repository_name != "" ? 1 : 0
  repository      = var.github_repository_name
  secret_name     = upper("GCP_${local.env}_BUCKET")
  plaintext_value = google_storage_bucket.web-host-service.name
}

resource "github_actions_secret" "url_map" {
  count           = var.github_repository_name != "" ? 1 : 0
  repository      = var.github_repository_name
  secret_name     = upper("GCP_${local.env}_URL_MAP")
  plaintext_value = google_compute_url_map.web-host-service.name
}

resource "github_actions_secret" "gcp_project" {
  count           = var.github_repository_name != "" ? 1 : 0
  repository      = var.github_repository_name
  secret_name     = upper("GCP_${local.env}_PROJECT")
  plaintext_value = data.google_client_config.current.project
}
