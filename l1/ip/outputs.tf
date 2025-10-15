output "name" {
  description = "Name of the address"
  value       = google_compute_address.this.name
}

output "address" {
  description = "The static external IP address represented by this resource"
  value       = google_compute_address.this.address
}

output "self_link" {
  description = "The URI of the created resource"
  value       = google_compute_address.this.self_link
}