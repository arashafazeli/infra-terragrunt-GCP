inputs = {
  name        = "aiven-mirrormaker-dev"
  description = "Temporary rule to allow Aiven MirrorMaker access to cluster"
  network     = "default"
  source_ranges = [
    "192.168.10.0/24"
  ]
  allow = [
    {
      protocol = "all"
      ports    = null
    }
  ]
}

include {
  path = find_in_parent_folders()
}

terraform {
  source = "${get_parent_terragrunt_dir()}/..//modules/gcp/network/firewall"
}

generate "providers" {
  path      = "providers.tf"
  if_exists = "overwrite"
  contents  = <<-EOF
    provider "google" {
      project = "play-gll-gg"
      region  = "europe-west1"
    }
    EOF
}
