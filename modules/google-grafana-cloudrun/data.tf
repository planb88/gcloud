data "google_project" "gcloud_project" {
  project_id = var.gcloud_project
}

data "google_compute_network" "vpc" {
  name = var.vpc_name
}

data "google_compute_subnetwork" "cloudrun_subnet" {
  name   = var.cloudrun_subnet_name
  region = var.gcloud_region
}

data "google_storage_bucket" "grafana_data" {
  name = var.data_bucket_name
}

data "google_secret_manager_secret" "grafana_db_password" {
  project   = data.google_project.gcloud_project.project_id
  secret_id = var.grafana_db_password_secret_name
}

data "google_secret_manager_secret" "grafana_admin_password" {
  project   = data.google_project.gcloud_project.project_id
  secret_id = var.grafana_admin_password_secret_name
}

data "google_secret_manager_secret" "grafana_secret_key" {
  project   = data.google_project.gcloud_project.project_id
  secret_id = var.grafana_secret_key_secret_name
}
