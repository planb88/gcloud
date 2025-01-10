locals {
  vpc_name          = "ip-${local.env_name}"
  gke_pods_cidr     = cidrsubnet(var.ipv4_cidr, 3, 0)
  gke_services_cidr = cidrsubnet(var.ipv4_cidr, 4, 3)
  gke_subnet_cidr   = cidrsubnet(var.ipv4_cidr, 4, 2)
  cr_subnet_cidr    = cidrsubnet(var.ipv4_cidr, 4, 4)
}

resource "google_compute_network" "vpc" {
  provider                = google-beta
  name                    = local.vpc_name
  auto_create_subnetworks = false
  routing_mode            = "REGIONAL"
}

resource "google_compute_subnetwork" "gke_subnet" {
  provider      = google-beta
  name          = "gke-${var.gcloud_region}"
  ip_cidr_range = local.gke_subnet_cidr
  region        = var.gcloud_region
  network       = google_compute_network.vpc.id
  secondary_ip_range {
    range_name    = "pods-subnet"
    ip_cidr_range = local.gke_pods_cidr
  }
  secondary_ip_range {
    range_name    = "services-subnet"
    ip_cidr_range = local.gke_services_cidr
  }
}

resource "google_compute_subnetwork" "cloudrun_subnet" {
  provider      = google-beta
  name          = "cloudrun-${var.gcloud_region}"
  ip_cidr_range = local.cr_subnet_cidr
  region        = var.gcloud_region
  network       = google_compute_network.vpc.id
}

/*
resource "google_compute_subnetwork" "l7lb_subnet" {
  provider      = google-beta
  region        = var.gcloud_region
  name          = local.l7lb_subnet_name
  ip_cidr_range = local.l7lb_subnet_cidr
  purpose       = "REGIONAL_MANAGED_PROXY"
  role          = "ACTIVE"
  network       = google_compute_network.vpc.id
}

resource "google_compute_subnetwork" "nat_subnet" {
  provider      = google-beta
  region        = var.gcloud_region
  name          = local.nat_subnet_name
  ip_cidr_range = local.nat_subnet_cidr
  purpose       = "PRIVATE_NAT"
  network       = google_compute_network.vpc.id
}
*/
