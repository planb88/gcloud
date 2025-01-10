resource "google_dns_managed_zone" "dns_zone" {
  name        = "simple-site1"
  dns_name    = "simple-site1.com."
  description = "DNS zone"
  labels = {
    path = "bootstrap"
  }
}

data "google_dns_keys" "dns_zone_keys" {
  managed_zone = google_dns_managed_zone.dns_zone.id
}

# output "foo_dns_ds_record" {
#   description = "DS record of the foo subdomain."
#   value       = data.google_dns_keys.dns_zone_keys.key_signing_keys[0].ds_record
# }
