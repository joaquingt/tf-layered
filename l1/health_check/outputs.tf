output "name" {
  description = "Name of the health check"
  value       = google_compute_health_check.this.name
}

output "id" {
  description = "The unique identifier for the health check"
  value       = google_compute_health_check.this.id
}

output "self_link" {
  description = "The URI of the created resource"
  value       = google_compute_health_check.this.self_link
}