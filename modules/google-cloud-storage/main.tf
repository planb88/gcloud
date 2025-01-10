data "google_project" "gcloud_project" {
  project_id = var.gcloud_project
}

resource "random_integer" "index" {
  min = 10
  max = 99
}

locals {
  bucket_name = var.bucket_name == "" ? "${var.bucket_name_prefix}-${random_integer.index.result}" : var.bucket_name
}

resource "google_storage_bucket" "bucket" {
  name          = local.bucket_name
  location      = var.bucket_location
  force_destroy = var.bucket_force_destroy
}
