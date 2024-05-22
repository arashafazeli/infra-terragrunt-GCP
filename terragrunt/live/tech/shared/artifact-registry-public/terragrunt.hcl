include {
  path = find_in_parent_folders()
}

terraform {
  source = "${get_parent_terragrunt_dir()}/..//modules/gcp/artifact-registry/"
}

prevent_destroy = true

inputs = {
  location = "europe-west1"
  name     = "artifact-public-registry"
  project  = "gloot-automation"
  format   = "DOCKER"
  member   = "allUsers"
}
