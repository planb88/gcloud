data "google_dns_managed_zone" "root_dns_zone" {
  name = var.root_dns_zone_name
}

output "dns_zone_name" {
  value = data.google_dns_managed_zone.root_dns_zone.name
}

output "dns_domain" {
  value = data.google_dns_managed_zone.root_dns_zone.dns_name
}
