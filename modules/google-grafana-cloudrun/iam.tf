data "google_iam_policy" "secret_accessor" {
  binding {
    role = "roles/secretmanager.secretAccessor"
    members = [
      "serviceAccount:${google_service_account.app_sa.email}",
    ]
  }
}

data "google_iam_policy" "noauth" {
  binding {
    role    = "roles/run.invoker"
    members = ["allUsers", ]
  }
}

resource "google_service_account" "app_sa" {
  project      = data.google_project.gcloud_project.project_id
  account_id   = local.service_name
  display_name = local.service_name
  description  = "Service account used by ${local.service_name} Service`"
}

resource "google_storage_bucket_iam_member" "grafana_data_storage_admin" {
  bucket = data.google_storage_bucket.grafana_data.name
  role   = "roles/storage.admin"
  member = "serviceAccount:${google_service_account.app_sa.email}"
}

resource "google_secret_manager_secret_iam_policy" "grafana_db_password_secret_accessor" {
  project     = data.google_project.gcloud_project.project_id
  secret_id   = data.google_secret_manager_secret.grafana_db_password.secret_id
  policy_data = data.google_iam_policy.secret_accessor.policy_data
}

resource "google_secret_manager_secret_iam_policy" "grafana_admin_password_secret_accessor" {
  project     = data.google_project.gcloud_project.project_id
  secret_id   = data.google_secret_manager_secret.grafana_admin_password.secret_id
  policy_data = data.google_iam_policy.secret_accessor.policy_data
}

resource "google_secret_manager_secret_iam_policy" "grafana_secret_key_secret_accessor" {
  project     = data.google_project.gcloud_project.project_id
  secret_id   = data.google_secret_manager_secret.grafana_secret_key.secret_id
  policy_data = data.google_iam_policy.secret_accessor.policy_data
}
