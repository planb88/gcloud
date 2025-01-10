locals {
  service_http_port   = var.grafana_container_port
  secret_files        = ["grafana-admin-password", "grafana-secret-key"]
  # secret_files        = ["grafana-db-password", "grafana-admin-password", "grafana-secret-key"]
  secret_vars = {
    "GF_DATABASE_PASSWORD" = "grafana-db-password"
    #   "GF_SECURITY_ADMIN_PASSWORD" = "grafana-admin-password"
    #   "GF_SECURITY_SECRET_KEY"     = "grafana-secret-key"
  }
  env_vars = {
    "GF_LOG_LEVEL"                     = "warn"
    "GF_LOG_CONSOLE_LEVEL"             = "warn"
    "GF_SECURITY_ADMIN_USER"           = "admin"
    "GF_SECURITY_ADMIN_PASSWORD__FILE" = "/secrets/grafana-admin-password"
    "GF_SECURITY_SECRET_KEY__FILE"     = "/secrets/grafana-secret-key"
    "GF_DATABASE_HOST"                 = "${var.grafana_db_host}:${var.grafana_db_port}"
    "GF_DATABASE_NAME"                 = var.grafana_db_name
    "GF_DATABASE_USER"                 = var.grafana_db_user
    "GF_DATABASE_TYPE"                 = "postgres"
    # "GF_DATABASE_PASSWORD__FILE"       = "/secrets/grafana-db-password"
    # "GF_AUTH_GOOGLE_CLIENT_ID__FILE"     = "/secrets/grafana_auth_google_client_id"
    # "GF_AUTH_GOOGLE_CLIENT_SECRET__FILE" = "/secrets/grafana_auth_google_client_secret"
  }
}

resource "google_cloud_run_v2_service" "app" {
  depends_on = [
    google_storage_bucket_iam_member.grafana_data_storage_admin,
    google_secret_manager_secret_iam_policy.grafana_admin_password_secret_accessor,
    google_secret_manager_secret_iam_policy.grafana_db_password_secret_accessor,
    google_secret_manager_secret_iam_policy.grafana_secret_key_secret_accessor
  ]
  name                = local.service_name
  client              = "cloud-console"
  location            = var.gcloud_region
  deletion_protection = false
  ingress             = "INGRESS_TRAFFIC_ALL"
  template {
    execution_environment = "EXECUTION_ENVIRONMENT_GEN2"
    service_account       = google_service_account.app_sa.email
    containers {
      name  = "grafana"
      image = "${var.grafana_container_image}:${var.grafana_container_image_version}"
      dynamic "env" {
        for_each = local.env_vars
        content {
          name  = env.key
          value = env.value
        }
      }
      dynamic "env" {
        for_each = local.secret_vars
        content {
          name = env.key
          value_source {
            secret_key_ref {
              secret  = env.value
              version = "latest"
            }
          }
        }
      }
      startup_probe {
        initial_delay_seconds = 20
        timeout_seconds       = 5
        period_seconds        = 5
        failure_threshold     = 1
        tcp_socket {
          port = local.service_http_port
        }
      }
      liveness_probe {
        http_get {
          path = var.grafana_liveness_probe
          port = local.service_http_port
        }
      }
      ports {
        container_port = local.service_http_port
        name           = "http1"
      }
      resources {
        cpu_idle          = true
        startup_cpu_boost = true
        limits = {
          "cpu"    = "1000m"
          "memory" = "512Mi"
        }
      }
      volume_mounts {
        name       = "grafana-data"
        mount_path = "/var/lib/grafana"
      }
      dynamic "volume_mounts" {
        for_each = local.secret_files
        content {
          mount_path = "/secrets/${volume_mounts.value}"
          name       = volume_mounts.value
        }
      }
    }
    scaling {
      max_instance_count = 1
      min_instance_count = 0
    }
    volumes {
      name = "grafana-data"
      gcs {
        # bucket    = google_storage_bucket.grafana_data.name
        bucket    = data.google_storage_bucket.grafana_data.name
        read_only = false
      }
    }
    dynamic "volumes" {
      for_each = local.secret_files
      content {
        name = volumes.value
        secret {
          default_mode = 0
          secret       = volumes.value
          items {
            mode    = 0
            path    = volumes.value
            version = "latest"
          }
        }
      }
    }
    vpc_access {
      egress = "ALL_TRAFFIC"
      network_interfaces {
        network    = data.google_compute_network.vpc.name
        subnetwork = data.google_compute_subnetwork.cloudrun_subnet.name
        tags       = [local.service_name]
      }
    }
  }
  traffic {
    percent = 100
    type    = "TRAFFIC_TARGET_ALLOCATION_TYPE_LATEST"
  }
}

resource "google_cloud_run_service_iam_policy" "noauth" {
  location    = google_cloud_run_v2_service.app.location
  project     = google_cloud_run_v2_service.app.project
  service     = google_cloud_run_v2_service.app.name
  policy_data = data.google_iam_policy.noauth.policy_data
}
