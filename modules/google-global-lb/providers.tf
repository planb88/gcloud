variable "gcloud_project" {
  type        = string
  description = "Main GCP project"
}

variable "gcloud_region" {
  type        = string
  description = "Main GCP region"
  default     = "europe-west4"
}

provider "google" {
  project = var.gcloud_project
  region  = var.gcloud_region
}

provider "google-beta" {
  project = var.gcloud_project
  region  = var.gcloud_region
}
