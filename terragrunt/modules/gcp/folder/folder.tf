resource "google_folder" "folder" {
  display_name = var.name
  parent       = var.parent
}

module "folder-iam" {
  source   = "./iam"
  folders  = [google_folder.folder.name]
  mode     = "additive"
  bindings = var.iam_bindings
}