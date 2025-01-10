# resource "google_compute_security_policy" "security_policy" {
#   name        = "${local.service_name}-armor-security-policy"
#   description = "Security policy will allow connection only from whitelisted IP ranges"
#   # Reject all traffic that hasn't been whitelisted.
#   rule {
#     action   = "deny(403)"
#     priority = "2147483647"
#     match {
#       versioned_expr = "SRC_IPS_V1"
#       config {
#         src_ip_ranges = ["*"]
#       }
#     }
#     description = "Default rule, higher priority overrides it"
#   }
#   # Whitelist traffic from certain ip address
#   rule {
#     action   = "allow"
#     priority = "1000"
#     match {
#       versioned_expr = "SRC_IPS_V1"
#       config {
#         src_ip_ranges = var.whitelist_ip_ranges
#       }
#     }
#     description = "allow traffic from whitelist IP ranges"
#   }
# }

resource "google_compute_region_network_endpoint_group" "neg" {
  project               = data.google_project.gcloud_project.project_id
  name                  = local.service_name
  region                = var.gcloud_region
  network_endpoint_type = "SERVERLESS"
  cloud_run {
    service = google_cloud_run_v2_service.app.name
  }
  lifecycle {
    create_before_destroy = true
  }
}

resource "google_compute_backend_service" "backend_service" {
  name                  = local.service_name
  protocol              = "HTTP"
  load_balancing_scheme = "EXTERNAL_MANAGED"
  # security_policy       = google_compute_security_policy.security_policy.self_link
  backend {
    group          = google_compute_region_network_endpoint_group.neg.id
    balancing_mode = "UTILIZATION"
  }
}
