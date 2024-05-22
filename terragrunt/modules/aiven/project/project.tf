resource "aiven_project" "project" {
  project   = var.project_name
  parent_id = var.parent_id
  technical_emails = [
    "esmaeil.ramnejadian@gloot.com",
    "mustafa@gloot.com",
  ]
}
