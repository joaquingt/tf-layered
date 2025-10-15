output "name" {
  description = "Name of the firewall rule"
  value       = google_compute_firewall.this.name
}

output "id" {
  description = "The ID of the firewall rule"
  value       = google_compute_firewall.this.id
}