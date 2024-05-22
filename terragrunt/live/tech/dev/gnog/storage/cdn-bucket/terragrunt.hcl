include {
  path = find_in_parent_folders()
}

terraform {
  source = "${get_parent_terragrunt_dir()}/..//modules/gcp/storage/gcp-bucket/"
}

dependency "project" {
  config_path = "${get_parent_terragrunt_dir()}/tech/dev/gnog/_project/"
  mock_outputs = {
    project_id = "invalid"
  }
  mock_outputs_allowed_terraform_commands = ["plan", "destroy"]
}

inputs = {
  location   = "europe-west1"
  project_id = dependency.project.outputs.project_id
  name       = "ai-cdn-media"
  iam_members = [{
    role   = "roles/storage.objectViewer"
    member = "allUsers"
  }]

  lifecycle_rules = [{
    action = {
      type          = "SetStorageClass"
      storage_class = "STANDARD"
    }
    condition = {
      age        = 150
      with_state = "ANY"
    }
    },
    {
      action = {
        type          = "SetStorageClass"
        storage_class = "NEARLINE"
      }
      condition = {
        age        = 250
        with_state = "ANY"
      }
    },
    {
      action = {
        type          = "SetStorageClass"
        storage_class = "COLDLINE"
      }
      condition = {
        age        = 360
        with_state = "ANY"
      }
    },
    {
      action = {
        type          = "SetStorageClass"
        storage_class = "ARCHIVE"
      }
      condition = {
        age        = 500
        with_state = "ANY"
      }
    }
  ]
}

generate "providers" {
  path      = "providers.tf"
  if_exists = "overwrite"
  contents  = <<-EOF
    data "google_client_config" "current" {}

    provider "google" {
      project = "${dependency.project.outputs.project_id}"
      region  = "europe-west1"
    }

    provider "google-beta" {
      project = "${dependency.project.outputs.project_id}"
      region  = "europe-west1"
    }
    EOF
}
