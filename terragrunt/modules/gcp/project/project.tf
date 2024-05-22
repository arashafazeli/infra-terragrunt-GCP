locals {
  # Some logic to handle env variable for both old dev, prod and new tech-folder
  env = length(regexall("/live/tech/(.*?)/", abspath(path.root))) > 0 ? regex("/live/tech/(.*?)/", abspath(path.root))[0] : regex("/live/(.*?)/", abspath(path.root))[0]
  labels = {
    kubernetes_label_env  = local.env
    kubernetes_label_team = var.team
  }
}

resource "random_id" "name" {
  byte_length = var.random_id_length
}

locals {
  name = "${var.name}-${local.env}"
  id   = "${local.name}-${random_id.name.hex}"
}

resource "google_project" "project" {
  name            = local.name
  project_id      = local.id
  billing_account = var.billing_account
  folder_id       = var.folder != "" ? var.folder : null
  org_id          = var.folder == "" ? var.organization_id : null
  labels          = local.labels
}

data "google_app_engine_default_service_account" "project" {
  project = google_project.project.project_id
}

resource "google_project_service" "project" {
  project                    = google_project.project.project_id
  disable_dependent_services = true
  for_each                   = var.services
  service                    = each.key
}

module "project-iam-bindings" {
  source   = "./iam"
  projects = [google_project.project.project_id]
  mode     = "additive"
  bindings = var.iam_bindings
}

resource "google_container_registry" "registry" {
  count    = var.create_container_registry ? 1 : 0
  project  = google_project.project.project_id
  location = "EU"
}

resource "google_app_engine_application" "app" {
  count       = var.create_app_engine_application ? 1 : 0
  project     = google_project.project.project_id
  location_id = "europe-west"
}
