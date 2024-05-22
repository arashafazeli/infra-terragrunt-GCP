resource "google_compute_firewall" "default" {
  name        = var.name
  description = var.description

  network   = var.network
  direction = var.direction
  priority  = var.priority
  disabled  = var.disabled

  source_ranges      = var.direction == "INGRESS" ? var.source_ranges : null
  destination_ranges = var.direction == "EGRESS" ? var.destination_ranges : null

  dynamic "allow" {
    for_each = var.allow
    content {
      protocol = allow.value.protocol
      ports    = allow.value.ports
    }
  }

  dynamic "deny" {
    for_each = var.deny
    content {
      protocol = deny.value.protocol
      ports    = deny.value.ports
    }
  }
}
