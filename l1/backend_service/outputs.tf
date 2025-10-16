output "name" {
  description = "Name of the backend service"
  value       = google_compute_region_backend_service.this.name
}

output "id" {
  description = "The unique identifier for the backend service"
  value       = google_compute_region_backend_service.this.id
}

output "self_link" {
  description = "The URI of the created resource"
  value       = google_compute_region_backend_service.this.self_link
}