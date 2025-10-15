output "name" {
  description = "The name of the VPC being created"
  value       = google_compute_network.this.name
}

output "id" {
  description = "The ID of the VPC being created"
  value       = google_compute_network.this.id
}

output "self_link" {
  description = "The URI of the VPC being created"
  value       = google_compute_network.this.self_link
}