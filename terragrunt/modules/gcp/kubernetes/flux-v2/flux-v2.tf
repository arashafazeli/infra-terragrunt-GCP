locals {
  known_hosts = "github.com ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBEmKSENjQEezOmxkZMy7opKgwFB9nkt5YRrYMjNuG5N87uRgg6CLrbo5wAdT/y6v0mKV0U2w0WZ2YB/++Tpockg="
  environment = length(regexall("/live/tech/(.*?)/", abspath(path.root))) > 0 ? regex("/live/tech/(.*?)/", abspath(path.root))[0] : regex("/live/(.*?)/", abspath(path.root))[0]
  labels = {
    app     = var.service_name
    env     = local.environment
    product = var.product
    team    = var.team
  }
}

resource "tls_private_key" "main" {
  algorithm   = "ECDSA"
  ecdsa_curve = "P521"
}

# Flux
data "flux_install" "main" {
  target_path      = var.target_path
  components_extra = ["image-automation-controller", "image-reflector-controller"]
}

data "flux_sync" "main" {
  target_path = var.target_path
  url         = "ssh://git@github.com/${var.github_owner}/${var.github_repository}.git"
  branch      = var.branch
}

# Kubernetes
resource "kubernetes_namespace" "flux_system" {
  metadata {
    name = "flux-system"
  }

  lifecycle {
    ignore_changes = [
      metadata[0].labels,
      metadata[0].annotations,
    ]
  }
}

data "kubectl_file_documents" "install" {
  content = data.flux_install.main.content
}

data "kubectl_file_documents" "sync" {
  content = data.flux_sync.main.content
}

locals {
  install = [for v in data.kubectl_file_documents.install.documents : {
    data : yamldecode(v)
    content : v
    }
  ]
  sync = [for v in data.kubectl_file_documents.sync.documents : {
    data : yamldecode(v)
    content : v
    }
  ]
  kustomization_patch = <<EOT
patches:
- target:
    version: v1
    group: apps
    kind: Deployment
    name: image-reflector-controller
    namespace: flux-system
  patch: |-
    - op: add
      path: /spec/template/spec/containers/0/args/-
      value: --gcp-autologin-for-gcr
patchesStrategicMerge:
- |-
  apiVersion: v1
  kind: ServiceAccount
  metadata:
    name: kustomize-controller
    namespace: flux-system
    annotations:
      iam.gke.io/gcp-service-account: ${module.sops-service-account.email}
- |-
  apiVersion: v1
  kind: ServiceAccount
  metadata:
    name: image-reflector-controller
    namespace: flux-system
    annotations:
      iam.gke.io/gcp-service-account: ${module.gcr-service-account.email}
EOT
}

resource "kubectl_manifest" "install" {
  for_each      = { for v in local.install : lower(join("/", compact([v.data.apiVersion, v.data.kind, lookup(v.data.metadata, "namespace", ""), v.data.metadata.name]))) => v.content }
  depends_on    = [kubernetes_namespace.flux_system]
  yaml_body     = each.value
  ignore_fields = ["metadata.annotations", "spec"]
}

resource "kubectl_manifest" "sync" {
  for_each   = { for v in local.sync : lower(join("/", compact([v.data.apiVersion, v.data.kind, lookup(v.data.metadata, "namespace", ""), v.data.metadata.name]))) => v.content }
  depends_on = [kubernetes_namespace.flux_system]
  yaml_body  = each.value
}

resource "kubernetes_secret" "main" {
  depends_on = [kubectl_manifest.install]

  metadata {
    name      = data.flux_sync.main.name
    namespace = data.flux_sync.main.namespace
  }

  data = {
    identity       = tls_private_key.main.private_key_pem
    "identity.pub" = tls_private_key.main.public_key_pem
    known_hosts    = local.known_hosts
  }
}

# GitHub - Temporary access to infra-flux repo
resource "tls_private_key" "infra-flux" {
  algorithm   = "ECDSA"
  ecdsa_curve = "P521"
}

resource "kubernetes_secret" "infra-flux" {
  depends_on = [kubectl_manifest.install]

  metadata {
    name      = "infra-flux"
    namespace = data.flux_sync.main.namespace
  }

  data = {
    identity       = tls_private_key.infra-flux.private_key_pem
    "identity.pub" = tls_private_key.infra-flux.public_key_pem
    known_hosts    = local.known_hosts
  }
}

resource "github_repository_deploy_key" "infra-flux" {
  title      = "flux-v2-${data.google_client_config.current.project}"
  repository = "infra-flux"
  key        = tls_private_key.infra-flux.public_key_openssh
  read_only  = true
}

# GitHub
data "github_repository" "main" {
  name = var.github_repository
}

resource "github_repository_deploy_key" "main" {
  title      = "flux-${data.google_client_config.current.project}"
  repository = data.github_repository.main.name
  key        = tls_private_key.main.public_key_openssh
  read_only  = false
}

resource "github_repository_file" "install" {
  repository          = data.github_repository.main.name
  file                = data.flux_install.main.path
  content             = data.flux_install.main.content
  branch              = var.branch
  overwrite_on_create = true
}

resource "github_repository_file" "sync" {
  repository          = data.github_repository.main.name
  file                = data.flux_sync.main.path
  content             = data.flux_sync.main.content
  branch              = var.branch
  overwrite_on_create = true
}

resource "github_repository_file" "kustomize" {
  repository          = data.github_repository.main.name
  file                = data.flux_sync.main.kustomize_path
  content             = "${data.flux_sync.main.kustomize_content}${local.kustomization_patch}"
  branch              = var.branch
  overwrite_on_create = true
}

#Cluster info config map
module "cluster_info" {
  source       = "./cluster-info"
  project_id   = data.google_client_config.current.project
  region       = data.google_client_config.current.region
  cluster_name = var.cluster_name
  dns_zone     = var.dns_zone
  labels       = local.labels
  namespace    = kubernetes_namespace.flux_system.metadata[0].name
}

#Flux sops kms
module "sops-kms" {
  source = "./kms"
  name   = "flux-${local.environment}"
}

module "sops-service-account" {
  source             = "./google-workload-identity-service-account"
  name               = "flux-sops-${local.environment}"
  kubernetes_sa_name = "kustomize-controller"
  namespace          = "flux-system"
  roles = [
    "roles/cloudkms.cryptoKeyEncrypterDecrypter",
  ]
}

# Flux GCR Service Account
module "gcr-service-account" {
  source             = "./google-workload-identity-service-account"
  name               = "flux-gcr-${local.environment}"
  kubernetes_sa_name = "image-reflector-controller"
  namespace          = "flux-system"
  roles = [
    "roles/storage.objectViewer",
  ]
}

resource "google_project_iam_member" "project" {
  project = "docker-registry-shared-cc74"
  role    = "roles/storage.objectViewer"
  member  = "serviceAccount:${module.gcr-service-account.email}"
}
