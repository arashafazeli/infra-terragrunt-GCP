include {
  path = find_in_parent_folders()
}

terraform {
  source = "${get_parent_terragrunt_dir()}/..//modules/gcp/monitoring/notification-channel"
}

inputs = {
  name = "opsgenie-notification-channel-prod"
  type = "webhook_tokenauth"
  labels = {
    url = "https://api.eu.opsgenie.com/v1/json/googlestackdriver?apiKey=${get_env("PROD_OLD_OPSGENIE_STACKDRIVER_TOKEN", "INVALID")}"
  }
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
