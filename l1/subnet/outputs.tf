output "name" {
  description = "The name of the subnet"
  value       = google_compute_subnetwork.this.name
}

output "id" {
  description = "The ID of the subnet"
  value       = google_compute_subnetwork.this.id
}

output "self_link" {
  description = "The URI of the subnet"
  value       = google_compute_subnetwork.this.self_link
}

output "ip_cidr_range" {
  description = "The range of IP addresses belonging to this subnetwork"
  value       = google_compute_subnetwork.this.ip_cidr_range
}