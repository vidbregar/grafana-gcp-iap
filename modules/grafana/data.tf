data "cloudflare_zone" "this" {
  name = join(".", slice(split(".", local.hostname), 1, 3))
}

data "google_compute_global_address" "gateway" {
  project = var.project
  name    = "gateway-ip"
}

data "kubernetes_resource" "gateway" {
  api_version = "gateway.networking.k8s.io/v1"
  kind        = "Gateway"

  metadata {
    name      = "gateway"
    namespace = "gateway"
  }

  depends_on = [helm_release.gateway]
}

data "google_secret_manager_secret_version" "admin_pass" {
  project = var.project
  secret  = "<gcp_secret_manager_secret_name>"
  version = "latest"
}

data "google_secret_manager_secret_version" "db_pass" {
  project = var.project
  secret  = "<gcp_secret_manager_secret_name>"
  version = "latest"
}
