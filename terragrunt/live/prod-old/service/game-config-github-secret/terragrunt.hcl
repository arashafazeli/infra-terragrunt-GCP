include {
  path = find_in_parent_folders()
}

terraform {
  source = "${get_parent_terragrunt_dir()}/..//modules/github/gloot-github-secrets"
}

inputs = {
  github_repository_name = "game-configurations"
  gloot_roles = [
    "FEATURE_GAME_ADMIN",
    "FEATURE_GAME_CONFIGURATION_EDIT",
    "FEATURE_GAME_STATUS_EDIT",
  "FEATURE_STATS_PROPERTIES_EDIT"]
  gloot_refresh_tokens = {
    core = ["SUPER_USER"]
  }
}
