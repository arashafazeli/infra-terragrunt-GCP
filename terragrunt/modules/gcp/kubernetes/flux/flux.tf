data "google_project" "project" {
}

resource "tls_private_key" "flux" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "random_id" "name" {
  byte_length = 2
}

locals {
  ho_service_account_name        = "ho-${var.namespace}-${random_id.name.hex}"
  ho_service_account_secret_name = "helm-operator-sa-secret"
  tmp_flux_config                = merge(var.default_flux_config, var.flux_config, { namespace = var.namespace })
  flux_config                    = merge(local.tmp_flux_config, { name = "${local.tmp_flux_config.name}-${var.namespace}" })
  tmp_flux_sets                  = merge(var.default_flux_config_sets, var.flux_config_sets)
  tmp_helm_config                = merge(var.default_helm_operator_config, var.helm_operator_config, { namespace = var.namespace })
  helm_config                    = merge(local.tmp_helm_config, { name = "${local.tmp_helm_config.name}-${var.namespace}" })
  helm_sets                      = merge(var.default_helm_operator_config_sets, var.helm_operator_config_sets, { "extraVolumes[0].secret.secretName" = local.ho_service_account_secret_name })
  flux_slack_integration_config  = merge(var.default_flux_slack_integration_config, var.flux_slack_integration_config)
  environment                    = split("/", local.tmp_flux_sets["git.path"])[1]
  labels = {
    app     = var.service_name
    env     = local.environment
    product = var.product
    team    = var.team
  }
}
/* Secret for private SSH key to access GitHub */
module "kubernetes-secret" {
  source    = "./secret"
  name      = local.helm_sets["git.ssh.secretName"]
  namespace = var.namespace
  data = {
    identity = tls_private_key.flux.private_key_pem
  }
  service_name = var.service_name
  product      = var.product
  team         = var.team
}
/* Let Flux access GitHub with public key */
resource "github_repository_deploy_key" "flux" {
  title      = "Flux - ${var.cluster_name}"
  repository = data.github_repository.flux-repo.name
  read_only  = false
  key        = tls_private_key.flux.public_key_openssh
}
/* Flux release */
module "flux-release" {
  source         = "./helm-release"
  release_config = local.flux_config
  sets           = local.flux_sets
}
/* General cluster info config map, used by cert-manager */
module "cluster-info" {
  source       = "./cluster-info"
  project_id   = data.google_project.project.project_id
  region       = var.region
  cluster_name = var.cluster_name
  dns_zone     = var.dns_zone
  labels       = local.labels
}
/* Helm Operator release */
module "helm-operator-release" {
  source         = "./helm-release"
  release_config = local.helm_config
  sets           = local.helm_sets
}
/* Helm Operator service account */
module "google_service_account" {
  source      = "./google-service-account"
  name        = local.ho_service_account_name
  namespace   = var.namespace
  secret_name = local.ho_service_account_secret_name
  roles       = []
  labels      = local.labels
}
/* Let Helm Operator service account access charts in gloot-automation */
resource "google_storage_bucket_iam_member" "helm_registry" {
  bucket = var.helm_registry_bucket
  role   = "roles/storage.objectViewer"
  member = module.google_service_account.service_account
}

/*
* Create GCP SA and allow it to fetch images from bucket, then allow Flux to use workload identity for that role.
* We're not using the google-service-account modules since we need google_storage_bucket_iam_member (and don't need the secrets).
* Exclude old dev and prod.
*/
locals {
  is_not_old_dev_or_prod = local.environment == "dev-old" || local.environment == "prod-old" ? false : true
  /*
  *  We might create the Kubernetes Service Account (flux_k8s_service_account) from scratch in the future,
  *  to easier handle the dependency graph. But for now we'll use the automated one by flux,
  *  to keep it for backward compability with dev-old and prod-old.
  */
  flux_google_service_account_id   = local.is_not_old_dev_or_prod ? "projects/${data.google_project.project.project_id}/serviceAccounts/${google_service_account.flux_google_service_account[0].email}" : null
  flux_google_service_account_name = local.is_not_old_dev_or_prod ? "serviceAccount:${google_service_account.flux_google_service_account[0].email}" : null
  flux_k8s_service_account         = local.is_not_old_dev_or_prod ? "serviceAccount:${data.google_project.project.project_id}.svc.id.goog[${var.namespace}/${local.flux_config.name}]" : null
  flux_sets                        = local.is_not_old_dev_or_prod ? merge(local.tmp_flux_sets, { "serviceAccount.annotations.iam\\.gke\\.io/gcp-service-account" = google_service_account.flux_google_service_account[0].email }) : local.tmp_flux_sets
}
// Setup service account
resource "google_service_account" "flux_google_service_account" {
  count      = local.is_not_old_dev_or_prod ? 1 : 0
  account_id = local.flux_config.name
  lifecycle {
    create_before_destroy = false
  }
}
// Let service account access the bucket
resource "google_storage_bucket_iam_member" "gcr_bucket" {
  count  = local.is_not_old_dev_or_prod ? 1 : 0
  bucket = var.docker_registry_bucket
  role   = "roles/storage.objectViewer"
  member = local.flux_google_service_account_name
}
// Let Flux kubernetes service account access the google service account
resource "google_service_account_iam_binding" "workload_identity" {
  count              = local.is_not_old_dev_or_prod ? 1 : 0
  service_account_id = local.flux_google_service_account_id
  role               = "roles/iam.workloadIdentityUser"

  members = [
    local.flux_k8s_service_account,
  ]
  depends_on = [module.flux-release]
}

/* Flux Slack integration */
resource "kubernetes_service" "flux-slack-integration" {
  provider = kubernetes
  metadata {
    name      = local.flux_slack_integration_config.name
    namespace = var.namespace
    labels    = local.labels
  }
  spec {
    selector = {
      name = local.flux_slack_integration_config.name
    }
    port {
      port        = local.flux_slack_integration_config.service_port
      target_port = local.flux_slack_integration_config.target_port
    }

    type = local.flux_slack_integration_config.service_type
  }
}
resource "kubernetes_deployment" "flux-slack-integration" {
  provider = kubernetes
  metadata {
    name      = "flux-slack-integration"
    namespace = var.namespace
    labels    = merge({ name = local.flux_slack_integration_config.name }, local.labels)
  }

  spec {
    replicas = local.flux_slack_integration_config.replicas

    selector {
      match_labels = {
        name = local.flux_slack_integration_config.name
      }
    }

    template {
      metadata {
        labels = merge({ name = local.flux_slack_integration_config.name }, local.labels)
      }

      spec {
        container {
          image = local.flux_slack_integration_config.image
          name  = local.flux_slack_integration_config.name

          env {
            name  = "SLACK_URL"
            value = local.flux_slack_integration_config.slack_url
          }
          env {
            name  = "SLACK_CHANNEL"
            value = local.flux_slack_integration_config.slack_channel
          }
          env {
            name  = "GITHUB_URL"
            value = local.flux_slack_integration_config.github_url
          }
          env {
            name  = "LISTEN_ADDRESS"
            value = ":${local.flux_slack_integration_config.target_port}"
          }
          env {
            name  = "TITLE_TEMPLATE"
            value = "[${upper(local.environment)}] {{ if eq .EventType \"commit\" }}Applying changes from commit{{ end }}{{ if eq .EventType \"autorelease\" }}Auto releasing resources{{ end }}"
          }
          env {
            name  = "BODY_TEMPLATE"
            value = <<EOT
{{ if or (eq .EventType "autorelease") (eq .EventType "commit") }}
{{ range $resourceName, $resourceResult := .EventResult }}
{{ if eq $resourceResult.Status "success" }}
{{ range $resourceResult.PerContainer }}
{{ if not (eq .Current.String .Target.String) }}
* Updating *{{ replace $resourceName.String ":fluxhelmrelease" "" }}* from *{{ .Current.Tag }}* to *{{ .Target.Tag }}*
{{ end }}
{{ end }}
{{ end }}
{{ if eq $resourceResult.Status "error" }}
*Error updating {{ replace $resourceName.String ":fluxhelmrelease" "" }}*
*Error message*: {{ $resourceResult.Error }}
{{ end }}
{{ end }}
{{ end }}
EOT
          }
          port {
            protocol       = "TCP"
            container_port = local.flux_slack_integration_config.target_port
          }
        }
        security_context {
          run_as_user = 999
        }
      }
    }
  }
}
