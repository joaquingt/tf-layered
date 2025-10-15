output "name" {
  description = "Name of the instance"
  value       = google_compute_instance.this.name
}

output "id" {
  description = "The server-assigned unique identifier of this instance"
  value       = google_compute_instance.this.id
}

output "self_link" {
  description = "The URI of the created resource"
  value       = google_compute_instance.this.self_link
}

output "internal_ip" {
  description = "The internal IP address of the instance"
  value       = google_compute_instance.this.network_interface.0.network_ip
}

output "external_ip" {
  description = "The external IP address of the instance"
  value       = try(google_compute_instance.this.network_interface.0.access_config.0.nat_ip, null)
}