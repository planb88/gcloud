data "google_dns_managed_zone" "dns_zone" {
  name = var.dns_zone_name
}

locals {
  env_name   = var.env_name == "" ? terraform.workspace : var.env_name
  dns_domain = trimsuffix(data.google_dns_managed_zone.dns_zone.dns_name, ".")
  dns_name   = "${var.service_name}.${data.google_dns_managed_zone.dns_zone.dns_name}"
  host_rules = {
    grafana = {
      hosts           = [local.dns_name]
      default_backend = var.backend_services_id
      paths = {
        "${var.backend_services_id}" = ["/"]
      }
    }
  }
}

resource "google_compute_global_address" "global_lb_pip" {
  provider   = google-beta
  project    = var.gcloud_project
  name       = "${local.env_name}-lb-address"
  ip_version = "IPV4"
}

data "google_compute_global_address" "global_lb_pip" {
  depends_on = [google_compute_global_address.global_lb_pip]
  name       = "${local.env_name}-lb-address"
  project    = var.gcloud_project
}

resource "google_dns_record_set" "lb_pip_dns_a_rec" {
  name         = local.dns_name
  type         = "A"
  ttl          = 300
  managed_zone = data.google_dns_managed_zone.dns_zone.name
  rrdatas      = [data.google_compute_global_address.global_lb_pip.address]
}

resource "google_compute_url_map" "urlmap" {
  name            = "${local.env_name}-urlmap"
  description     = "${local.env_name} Url Map"
  default_service = var.backend_services_id
  dynamic "host_rule" {
    for_each = local.host_rules
    content {
      hosts        = host_rule.value["hosts"]
      path_matcher = host_rule.key
    }
  }
  dynamic "path_matcher" {
    for_each = local.host_rules
    content {
      name            = path_matcher.key
      default_service = path_matcher.value["default_backend"]
      dynamic "path_rule" {
        for_each = path_matcher.value["paths"]
        content {
          paths   = path_rule.value
          service = path_rule.key
        }
      }
    }
  }
}

resource "google_certificate_manager_certificate_map" "global_lb" {
  name        = "${local.env_name}-lb-cert-map"
  description = "${local.env_name} LoadBalancer certificate map"
}

resource "google_certificate_manager_certificate_map_entry" "global_lb_root_entry" {
  name         = "${local.env_name}-lb-cert-map-root-entry"
  map          = google_certificate_manager_certificate_map.global_lb.name
  certificates = [var.certificate_id]
  hostname     = local.dns_domain
}

resource "google_certificate_manager_certificate_map_entry" "global_lb_wildcard_entry" {
  name         = "${local.env_name}-lb-cert-map-wildcard-entry"
  map          = google_certificate_manager_certificate_map.global_lb.name
  certificates = [var.certificate_id]
  hostname     = "*.${local.dns_domain}"
}

resource "google_compute_target_http_proxy" "http_proxy" {
  provider = google-beta
  project  = var.gcloud_project
  name     = "${local.env_name}-lb-http-proxy"
  url_map  = google_compute_url_map.urlmap.id
}

resource "google_compute_target_https_proxy" "https_proxy" {
  provider        = google-beta
  project         = var.gcloud_project
  name            = "${local.env_name}-lb-https-proxy"
  url_map         = google_compute_url_map.urlmap.id
  certificate_map = "//certificatemanager.googleapis.com/${google_certificate_manager_certificate_map.global_lb.id}"
}

resource "google_compute_global_forwarding_rule" "https" {
  provider              = google-beta
  project               = var.gcloud_project
  name                  = "${local.env_name}-lb-https"
  target                = google_compute_target_https_proxy.https_proxy.self_link
  ip_address            = data.google_compute_global_address.global_lb_pip.address
  port_range            = "443"
  load_balancing_scheme = "EXTERNAL_MANAGED"
}

resource "google_compute_global_forwarding_rule" "http" {
  provider              = google-beta
  project               = var.gcloud_project
  name                  = "${local.env_name}-lb-http"
  target                = google_compute_target_http_proxy.http_proxy.self_link
  ip_address            = data.google_compute_global_address.global_lb_pip.address
  port_range            = "80"
  load_balancing_scheme = "EXTERNAL_MANAGED"
}
