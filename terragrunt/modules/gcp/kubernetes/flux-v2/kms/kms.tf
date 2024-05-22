resource "google_kms_key_ring" "keyring" {
  name     = var.name
  location = var.location
}

resource "google_kms_crypto_key" "crypto_key" {
  name            = var.name
  key_ring        = google_kms_key_ring.keyring.id
  rotation_period = var.rotation_period

  lifecycle {
    prevent_destroy = true
  }
}
