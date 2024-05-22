// Define tags as locals so they can be interpolated off of + exported
locals {
  public              = "public"
  public_restricted   = "public-restricted"
  private             = "private"
  private_persistence = "private-persistence"
}

# ---------------------------------------------------------------------------------------------------------------------
# public - allow ingress from anywhere
# ---------------------------------------------------------------------------------------------------------------------

resource "google_compute_firewall" "public_allow_all_inbound" {
  count = var.allow_all_inbound ? 1 : 0

  name          = "${var.name_prefix}-public-allow-ingress"
  network       = var.network
  target_tags   = [local.public]
  direction     = "INGRESS"
  source_ranges = ["0.0.0.0/0"]
  priority      = "1000"

  allow {
    protocol = "all"
  }
}

# ---------------------------------------------------------------------------------------------------------------------
# public - allow ingress from specific sources
# ---------------------------------------------------------------------------------------------------------------------

resource "google_compute_firewall" "public_restricted_allow_inbound" {

  count = length(var.allowed_public_restricted_subnetworks) > 0 ? 1 : 0

  name = "${var.name_prefix}-public-restricted-allow-ingress"

  network = var.network

  target_tags   = [local.public_restricted]
  direction     = "INGRESS"
  source_ranges = var.allowed_public_restricted_subnetworks

  priority = "1000"

  allow {
    protocol = "all"
  }
}

# ---------------------------------------------------------------------------------------------------------------------
# private - allow ingress from within this network
# ---------------------------------------------------------------------------------------------------------------------

resource "google_compute_firewall" "private_allow_all_network_inbound" {
  name = "${var.name_prefix}-private-allow-ingress"

  network = var.network

  target_tags = [local.private]
  direction   = "INGRESS"

  source_ranges = var.source_ranges

  priority = "1000"

  allow {
    protocol = "all"
  }
}

# ---------------------------------------------------------------------------------------------------------------------
# private-persistence - allow ingress from `private` and `private-persistence` instances in this network
# ---------------------------------------------------------------------------------------------------------------------

resource "google_compute_firewall" "private_allow_restricted_network_inbound" {
  name = "${var.name_prefix}-allow-restricted-inbound"

  network = var.network

  target_tags = [local.private_persistence]
  direction   = "INGRESS"

  # source_tags is implicitly within this network; tags are only applied to instances that rest within the same network
  source_tags = [local.private, local.private_persistence]

  priority = "1000"

  allow {
    protocol = "all"
  }
}

# ---------------------------------------------------------------------------------------------------------------------
# Allow SSH through IAP
# ---------------------------------------------------------------------------------------------------------------------

resource "google_compute_firewall" "iap" {
  name    = "iap-ssh"
  network = var.network
  # IAP's TCP forwarding netblock
  source_ranges = ["35.235.240.0/20"]
  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
}

# ---------------------------------------------------------------------------------------------------------------------
# Drop all
# ---------------------------------------------------------------------------------------------------------------------

resource "google_compute_firewall" "drop_all_private" {
  name = "${var.name_prefix}-drop-all"

  network = var.network

  target_tags   = [local.public]
  direction     = "INGRESS"
  source_ranges = ["0.0.0.0/0"]

  priority = "2000"

  deny {
    protocol = "all"
  }
}
