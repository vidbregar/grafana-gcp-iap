# Select the correct constants using conditionals
# based on the var.project
locals {
  namespace = "monitoring"
  hostname = "grafana.example.com"

  database = {
    name = "grafana"
    user = "grafana"
  }

  # Run the following command to get the brand:
  # gcloud iap oauth-brands list --project <project-name>
  oauth_brand = "projects/XXXXXXXXXXXX/brands/XXXXXXXXXXXX"

  iap_accessors_group = "grafana-accessors@example.com"
}
