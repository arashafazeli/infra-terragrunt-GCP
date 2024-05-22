variable "region" {
  type = string
}

variable "service_name" {
  type    = string
  default = "flux"
}

variable "team" {
  type = string
}

variable "product" {
  type = string
}

variable "cluster_name" {
  type = string
}

variable "dns_zone" {
  type    = string
  default = "" // Remove when old dev and prod are gone.
}

variable "namespace" {
  type    = string
  default = "core"
}

variable "docker_registry_bucket" {
  type = string
}

variable "default_flux_config" {
  type = any
  default = {
    chart      = "flux"
    version    = "1.2.0"
    repository = "https://charts.fluxcd.io"
    name       = "flux"
  }
}

variable "flux_config" {
  type    = any
  default = {}
}

variable "default_flux_config_sets" {
  type = map(any)
  default = {
    "git.url"                       = "git@github.com:g-loot/infra-flux"
    "git.pollInterval"              = "2m"
    "registry.automationInterval"   = "2m"
    "git.secretName"                = "custom-flux-git-deploy"
    "syncGarbageCollection.enabled" = "true"
    "additionalArgs[0]"             = "--connect=ws://fluxcloud"
    "additionalArgs[1]"             = "--log-format=json"
  }
}

variable "flux_config_sets" {
  type    = map(any)
  default = {}
}

variable "default_helm_operator_config" {
  type = any
  default = {
    chart      = "helm-operator"
    version    = "0.7.0"
    repository = "https://charts.fluxcd.io"
    name       = "helm-operator"
  }
}

variable "helm_operator_config" {
  type    = any
  default = {}
}

variable "default_helm_operator_config_sets" {
  type = map(any)
  default = {
    "git.ssh.secretName"                         = "custom-flux-git-deploy"
    "helm.versions"                              = "v3"
    "git.pollInterval"                           = "2m"
    "chartsSyncInterval"                         = "2m"
    "initPlugins.enable"                         = "true"
    "initPlugins.plugins[0].plugin"              = "https://github.com/hayorov/helm-gcs"
    "initPlugins.plugins[0].version"             = "0.3.1"
    "initPlugins.plugins[0].helmVersion"         = "v3"
    "extraVolumes[0].name"                       = "credentials"
    "extraVolumeMounts[0].name"                  = "credentials"
    "extraVolumeMounts[0].mountPath"             = "/serviceAccount"
    "extraVolumeMounts[0].readOnly"              = "true"
    "extraEnvs[0].name"                          = "GOOGLE_APPLICATION_CREDENTIALS"
    "extraEnvs[0].value"                         = "/serviceAccount/credentials.json"
    "configureRepositories.enable"               = "true"
    "configureRepositories.repositories[0].name" = "gloot-charts"
    "configureRepositories.repositories[0].url"  = "gs://gloot-charts"
    "resources.requests.ephemeral-storage"       = "1Gi"
  }
}

variable "helm_registry_bucket" {
  type    = string
  default = "gloot-charts"
}

variable "helm_operator_config_sets" {
  type    = map(any)
  default = {}
}

variable "default_flux_slack_integration_config" {
  type = any
  default = {
    name          = "fluxcloud"
    target_port   = 3032
    service_port  = 80
    service_type  = "ClusterIP"
    replicas      = 1
    image         = "justinbarrick/fluxcloud:v0.3.9"
    slack_url     = "https://hooks.slack.com/services/x/x/x"
    slack_channel = "#infra-flux-logs"
    github_url    = "https://github.com/g-loot/infra-flux"
  }
}

variable "flux_slack_integration_config" {
  type    = any
  default = {}
}
