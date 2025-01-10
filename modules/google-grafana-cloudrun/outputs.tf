output "service_address" {
  value = google_cloud_run_v2_service.app.uri
}

output "service_name" {
  value = local.service_name
}

output "backend_services_id" {
  value = google_compute_backend_service.backend_service.id
}
