output "vpc_id" {
  value = google_compute_network.vpc.id
}

output "vpc_name" {
  value = google_compute_network.vpc.name
}

output "gke_subnet_id" {
  value = google_compute_subnetwork.gke_subnet.id
}

output "gke_subnet_name" {
  value = google_compute_subnetwork.gke_subnet.name
}

output "cloudrun_subnet_name" {
  value = google_compute_subnetwork.cloudrun_subnet.name
}

# output "gke_pods_cidr" {
#   value = local.gke_pods_cidr
# }
#
# output "gke_services_cidr" {
#   value = local.gke_services_cidr
# }
#
# output "gke_subnet_cidr" {
#   value = local.gke_subnet_cidr
# }
#
# output "l7lb_subnet_cidr" {
#   value = local.l7lb_subnet_cidr
# }
#
# output "nat_subnet_cidr" {
#   value = local.nat_subnet_cidr
# }
#
# data "google_compute_regions" "available" {
# }
#
# output "google_compute_regions" {
#   value = data.google_compute_regions.available.names
# }
#
# output "gcloud_region" {
#   value = var.gcloud_region
# }
