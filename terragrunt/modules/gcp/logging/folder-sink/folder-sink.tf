resource "google_logging_folder_sink" "folder_sink" {
  name        = var.name
  description = var.description
  disabled    = !var.enabled

  folder      = var.folder
  destination = var.destination

  filter = var.filter
}

resource "google_project_iam_member" "project_iam_additive" {
  project = var.iam_binding.project
  role    = var.iam_binding.role
  member  = google_logging_folder_sink.folder_sink.writer_identity
}
