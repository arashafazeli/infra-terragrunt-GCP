
data "google_service_account" "preexisting1" {
  account_id = var.name1
}

data "google_service_account" "preexisting2" {
  account_id = var.name2
}

module "github-wif" {
  source = "../wif"

  project_id = var.project_id

  pool_id     = var.pool_id
  provider_id = var.provider_id

  attribute_mapping = {
    "google.subject"             = "assertion.sub"
    "attribute.actor"            = "assertion.actor"
    "attribute.repository_owner" = "assertion.repository_owner"
    "attribute.repository"       = "assertion.repository"
  }
  issuer_uri = "https://token.actions.githubusercontent.com"

  service_accounts = [
    {
      name           = data.google_service_account.preexisting1.name
      attribute      = var.attribute
      all_identities = true
    },
    {
      name           = data.google_service_account.preexisting2.name
      attribute      = var.attribute
      all_identities = true
    }
  ]
}
