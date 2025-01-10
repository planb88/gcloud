resource "google_compute_address" "nat_ip_addresses" {
  count  = var.nat_ip_addresses_count
  name   = "${local.env_name}-nat-ip-${count.index}-${var.gcloud_region}"
  region = var.gcloud_region
  lifecycle {
    create_before_destroy = true
  }
}

# import {
#   id = "projects/${var.gcloud_project}/regions/${var.gcloud_region}/addresses/default-nat-ip-0-europe-west4"
#   to = google_compute_address.nat_ip_addresses[0]
# }

resource "google_compute_router" "router" {
  name    = "${local.env_name}-router-${var.gcloud_region}"
  region  = var.gcloud_region
  network = google_compute_network.vpc.id
}

# import {
#   id = "projects/${var.gcloud_project}/regions/${var.gcloud_region}/routers/${local.env_name}-router-${var.gcloud_region}"
#   to = google_compute_router.router
# }

resource "google_compute_router_nat" "cloud_nat" {
  name                               = "${local.env_name}-router-nat"
  router                             = google_compute_router.router.name
  region                             = google_compute_router.router.region
  nat_ip_allocate_option             = "MANUAL_ONLY"
  nat_ips                            = google_compute_address.nat_ip_addresses.*.self_link
  source_subnetwork_ip_ranges_to_nat = "LIST_OF_SUBNETWORKS"
  subnetwork {
    name                    = google_compute_subnetwork.gke_subnet.name
    source_ip_ranges_to_nat = ["ALL_IP_RANGES"]
  }
  subnetwork {
    name                    = google_compute_subnetwork.cloudrun_subnet.name
    source_ip_ranges_to_nat = ["ALL_IP_RANGES"]
  }
}

# import {
#   id = "projects/${var.gcloud_project}/regions/${var.gcloud_region}/routers/${local.env_name}-router-${var.gcloud_region}/${local.env_name}-router-nat"
#   to = google_compute_router_nat.cloud_nat
# }
