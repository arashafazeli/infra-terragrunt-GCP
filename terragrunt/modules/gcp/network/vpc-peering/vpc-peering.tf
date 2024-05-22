resource "google_compute_network_peering" "peeringconnection" {
  name                 = var.name
  network              = var.network_id
  peer_network         = var.peer_network_id
  import_custom_routes = var.import_custom_routes
  export_custom_routes = var.export_custom_routes
}