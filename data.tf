data "google_container_cluster" "this" {
  project  = local.gcp_project_name
  name     = "my-cluster-name"
  location = "my-location"
}

data "google_client_config" "provider" {}
