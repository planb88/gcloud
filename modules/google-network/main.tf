locals {
  env_name = var.env_name == "" ? terraform.workspace : var.env_name
}

data "google_compute_zones" "available" {
  region = var.gcloud_region
}
