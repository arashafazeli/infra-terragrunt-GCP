resource "google_storage_bucket" "ai-bucket" {
  name          = var.name
  project       = var.project
  location      = var.location
  force_destroy = var.force_destroy
  lifecycle_rule {
    condition {
      age = 150
    }
    action {
      type          = "SetStorageClass"
      storage_class = "STANDARD"
    }
  }

  lifecycle_rule {
    condition {
      age = 250
    }
    action {
      type          = "SetStorageClass"
      storage_class = "NEARLINE"
    }
  }
  lifecycle_rule {
    condition {
      age = 360
    }
    action {
      type          = "SetStorageClass"
      storage_class = "COLDLINE"
    }
  }

  lifecycle_rule {
    condition {
      age = 500
    }
    action {
      type          = "SetStorageClass"
      storage_class = "ARCHIVE"
    }
  }
}
