remote_state {
  backend = "gcs"
  config = {
    bucket   = "gloot-terraform-state"
    prefix   = "${path_relative_to_include()}/"
    project  = "gloot-automation"
    location = "europe-north1"
  }
}

retryable_errors = [
  "(?s).*Failed to load state.*tcp.*timeout.*",
  "(?s).*Failed to load backend.*TLS handshake timeout.*",
  "(?s).*Creating metric alarm failed.*request to update this alarm is in progress.*",
  "(?s).*Error installing provider.*TLS handshake timeout.*",
  "(?s).*Error configuring the backend.*TLS handshake timeout.*",
  "(?s).*Error installing provider.*tcp.*timeout.*",
  "(?s).*Error installing provider.*tcp.*connection reset by peer.*",
  "NoSuchBucket: The specified bucket does not exist",
  "(?s).*Error creating SSM parameter: TooManyUpdates:.*",
  "(?s).*Failed to open state.*TLS handshake timeout.*",
  "(?s).*unexpected status code %!d(string=POST) when doing (?s) for id: (?s) and role: %!s(int=503)",
  "(?s).* rateLimitExceeded",
  "(?s).*aiven.*",
  "(?s).Required plugins are not installed.*",
  "(?s).*Could not load plugin.*"
]


generate "main" {
  path      = "main.tf"
  if_exists = "overwrite"
  contents  = <<-EOF
    terraform {
      backend "gcs" {}
      required_providers {
        aiven = {
          source = "aiven/aiven"
          version = "4.9.4"
        }
        flux = {
          source = "fluxcd/flux"
          version = "~> 0.22.3"
        }
        github = {
            source = "integrations/github"
            version = "4.11.0"
        }
        external = {
           source = "hashicorp/external"
           version = "2.3.1"
        }
        gloot = {
          source  = "terraform.gloot.com/providers/gloot"
          version = "0.0.11"
        }
        google = {
          source  = "hashicorp/google"
          version = "~> 5.9.0"
        }
        google-beta = {
          source  = "hashicorp/google-beta"
          version = "~> 5.9.0"
        }
        helm = {
          source = "hashicorp/helm"
          version = "~> 1.2.1"
        }
        kubectl = {
          source = "gavinbunney/kubectl"
          version = "~> 1.10.0"
        }
        kubernetes = {
          source  = "hashicorp/kubernetes"
          version = "2.23.0"
        }
        null = {
          source  = "hashicorp/null"
          version = "3.2.1"
        }
        random = {
          source  = "hashicorp/random"
          version = "3.6.0"
        }
        template = {
          source  = "hashicorp/template"
          version = "2.2.0"
        }
        tls = {
          source  = "hashicorp/tls"
          version = "2.1.1"
        }
      }
      required_version = ">= 0.13"
    }
    provider "aiven" {
      api_token = "${get_env("AIVEN_TOKEN", "INVALID")}"
    }
    provider "flux" {}
    provider "gloot" {}
    provider "github" {
      owner = "g-loot"
      base_url     = "https://api.github.com/"
    }
    EOF
}
