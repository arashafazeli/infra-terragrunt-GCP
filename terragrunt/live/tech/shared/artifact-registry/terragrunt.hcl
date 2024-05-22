include {
  path = find_in_parent_folders()
}

terraform {
  source = "${get_parent_terragrunt_dir()}/..//modules/gcp/artifact-registry/"
}

prevent_destroy = true

inputs = {
  location = "europe-west1"
  name     = "artifact-shared-registry"
  project  = "docker-registry-shared-cc74"
  format   = "DOCKER"
  member   = "serviceAccount:workload-identity-service@docker-registry-shared-cc74.iam.gserviceaccount.com"
}
