include {
  path = find_in_parent_folders()
}

terraform {
  source = "${get_parent_terragrunt_dir()}/..//modules/aiven/account/"
}

prevent_destroy = true

inputs = {
  account_name = "G-Loot"
}
