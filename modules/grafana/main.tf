resource "helm_release" "grafana" {
  name             = "grafana"
  repository       = "https://grafana.github.io/helm-charts"
  chart            = "grafana"
  version          = "8.8.1" # Grafana version 11.4.0
  wait             = false
  atomic           = true
  force_update     = false
  namespace        = local.namespace
  create_namespace = true

  values = [file("${path.module}/files/values.yaml")]

  set {
    name  = "database.host"
    value = "<host>:5432"
  }
  set {
    name  = "database.name"
    value = local.database.name
  }
  set {
    name  = "database.user"
    value = local.database.user
  }

  set {
    name  = "podAnnotations.checksum/env"
    value = sha256(nonsensitive(jsonencode(kubernetes_secret.env.data)))
  }

  set {
    name  = "podAnnotations.checksum/admin"
    value = sha256(nonsensitive(jsonencode(kubernetes_secret.admin.data)))
  }
}

# Example only, consider External Secrets Operator, Kubernetes Secrets Store CSI Driver, ...
resource "kubernetes_secret" "admin" {
  metadata {
    name      = "grafana-admin"
    namespace = local.namespace
  }
  type = "Opaque"

  data = {
    admin-user     = "admin_login_should_be_almost_always_disabled"
    admin-password = data.google_secret_manager_secret_version.admin_pass.secret_data
  }
}

# Example only, consider External Secrets Operator, Kubernetes Secrets Store CSI Driver, ...
resource "kubernetes_secret" "env" {
  metadata {
    name      = "grafana-env"
    namespace = local.namespace
  }
  type = "Opaque"

  data = {
    GF_AUTH_GOOGLE_CLIENT_SECRET = google_iap_client.grafana.secret
    GF_AUTH_GOOGLE_CLIENT_ID     = google_iap_client.grafana.client_id
    GF_DATABASE_PASSWORD         = data.google_secret_manager_secret_version.db_pass.secret_data
  }
}
