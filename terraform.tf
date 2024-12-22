terraform {
  required_version = ">= 1.9.0"

#   backend "gcs" {
#     bucket = "my-tf-state-bucket"
#     prefix = "grafana/my-env"
#   }

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "6.13.0"
    }

    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.35.0"
    }

    helm = {
      source  = "hashicorp/helm"
      version = "2.16.1"
    }
  }
}

provider "google" {
  project = local.gcp_project_name
}

provider "helm" {
  debug = false

  kubernetes {
    host                   = "https://${data.google_container_cluster.this.endpoint}"
    token                  = data.google_client_config.provider.access_token
    cluster_ca_certificate = base64decode(data.google_container_cluster.this.master_auth.0.cluster_ca_certificate)
  }

  experiments {
    manifest = true
  }
}

provider "kubernetes" {
  host                   = "https://${data.google_container_cluster.this.endpoint}"
  token                  = data.google_client_config.provider.access_token
  cluster_ca_certificate = base64decode(data.google_container_cluster.this.master_auth.0.cluster_ca_certificate)
}
