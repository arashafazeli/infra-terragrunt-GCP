resource "random_id" "name" {
  byte_length = var.random_id_length
}


locals {
  name = var.name
  id   = "${local.name}-${random_id.name.hex}"
}

resource "google_artifact_registry_repository" "acr-repo" {
  location      = var.location
  repository_id = local.id
  description   = var.description
  format        = var.format
  project       = var.project

  docker_config {
    immutable_tags = true
  }
}
resource "google_artifact_registry_repository_iam_member" "member" {
  project    = google_artifact_registry_repository.acr-repo.project
  location   = google_artifact_registry_repository.acr-repo.location
  repository = google_artifact_registry_repository.acr-repo.name
  role       = "roles/artifactregistry.writer"
  member     = var.member
}
