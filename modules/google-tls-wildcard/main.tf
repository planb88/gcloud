data "google_dns_managed_zone" "dns_zone" {
  name = var.dns_zone_name
}

locals {
  env_name                  = var.env_name == "" ? terraform.workspace : var.env_name
  dns_domain                = trimsuffix(data.google_dns_managed_zone.dns_zone.dns_name, ".")
  certificate_cns           = [local.dns_domain, "*.${local.dns_domain}"]
  dns_authorization_domains = toset([for dom in local.certificate_cns : dom if !strcontains(dom, "*.")])
}

resource "google_certificate_manager_dns_authorization" "domain" {
  for_each = local.dns_authorization_domains
  project  = var.gcloud_project
  name     = "${replace(each.key, ".", "-")}-dns-authorization"
  type     = "PER_PROJECT_RECORD"
  domain   = each.key
}

resource "google_dns_record_set" "dns_authorization" {
  project      = var.gcloud_project
  name         = google_certificate_manager_dns_authorization.domain[local.dns_domain].dns_resource_record.0.name
  type         = google_certificate_manager_dns_authorization.domain[local.dns_domain].dns_resource_record.0.type
  ttl          = 60
  managed_zone = data.google_dns_managed_zone.dns_zone.name
  rrdatas      = [google_certificate_manager_dns_authorization.domain[local.dns_domain].dns_resource_record.0.data]
}

resource "google_certificate_manager_certificate" "wildcard" {
  project = var.gcloud_project
  name    = "${local.env_name}-wildcard-certificate"
  scope   = "DEFAULT"
  managed {
    domains            = local.certificate_cns
    dns_authorizations = [for dom in local.dns_authorization_domains : google_certificate_manager_dns_authorization.domain[dom].id]
  }
}

resource "google_certificate_manager_certificate_map" "domain" {
  name        = "${local.env_name}-certificates-map"
  project     = var.gcloud_project
  description = "${local.env_name} certificate map"
  lifecycle {
    create_before_destroy = true
  }
}

resource "google_certificate_manager_certificate_map_entry" "domain_root_entry" {
  for_each     = local.dns_authorization_domains
  name         = "${replace(each.key, ".", "-")}-map-root-entry"
  project      = var.gcloud_project
  map          = google_certificate_manager_certificate_map.domain.name
  certificates = [google_certificate_manager_certificate.wildcard.id]
  hostname     = each.key
}

resource "google_certificate_manager_certificate_map_entry" "global_lb_wildcard_entry" {
  for_each     = toset([for dom in local.certificate_cns : dom if strcontains(dom, "*")])
  name         = "${replace(replace(each.key, ".", "-"), "*", "wildcard")}-map-entry"
  project      = var.gcloud_project
  map          = google_certificate_manager_certificate_map.domain.name
  certificates = [google_certificate_manager_certificate.wildcard.id]
  hostname     = each.key
}
