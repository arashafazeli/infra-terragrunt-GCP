resource "aiven_gcp_vpc_peering_connection" "peeringconnection" {
  vpc_id         = var.vpc_id
  gcp_project_id = var.gcp_project_id
  peer_vpc       = var.peer_vpc

  timeouts {
    create = "10m"
  }
}
