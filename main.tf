locals {
  gcp_project_name = "my-gcp-project"
}

# For example purposes only!
module "grafana" {
  source = "./modules/grafana"

  project = local.gcp_project_name
}
