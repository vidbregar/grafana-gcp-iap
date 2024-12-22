# We assume that the Gateway already exists:
# https://cloud.google.com/kubernetes-engine/docs/how-to/deploying-gateways#external-gateway
# This helm chart will only setup up a route, health check and backend policy
resource "helm_release" "gateway" {
  name         = "grafana-gateway"
  namespace    = local.namespace
  chart        = "${path.module}/grafana-gateway"
  wait         = false
  force_update = false
  atomic       = true

  set {
    name  = "hostname"
    value = local.hostname
  }
  set {
    name  = "oauth.client_id"
    value = google_iap_client.grafana.client_id
  }
  set_sensitive {
    name  = "oauth.secret"
    value = google_iap_client.grafana.secret
  }

  depends_on = [
    helm_release.grafana,
    cloudflare_record.dns_record
  ]
}

# Add grafana.example.com DNS record
# Example for Cloudflare, but adapt to your DNS provider
resource "cloudflare_record" "dns_record" {
  zone_id = data.cloudflare_zone.this.id
  name    = local.hostname
  content = data.google_compute_global_address.gateway.address
  type    = "A"
  ttl     = 1
  proxied = true
}

resource "google_iap_client" "grafana" {
  display_name = "Grafana"
  brand        = local.oauth_brand
}

# Since it may take a few minutes to add the annotations,
# when applying for the first time,you might get an error.
# Wait a few minutes until you can see the Backend Service
# in the dashboard and then apply again.
resource "google_iap_web_backend_service_iam_member" "member" {
  project = var.project
  web_backend_service = (
    reverse(
      split("/",
        [for x in split(", ",
          data.kubernetes_resource.gateway.object.metadata.annotations["networking.gke.io/backend-services"],
        ) : x if strcontains(x, "${local.namespace}-${helm_release.grafana.name}-80")][0]
      )
    )[0]
  )
  role   = "roles/iap.httpsResourceAccessor"
  member = "group:${local.iap_accessors_group}"
}
