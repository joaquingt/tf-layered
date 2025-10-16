output "name" {
  description = "Name of the forwarding rule"
  value       = google_compute_forwarding_rule.this.name
}

output "id" {
  description = "The unique identifier for the forwarding rule"
  value       = google_compute_forwarding_rule.this.id
}

output "self_link" {
  description = "The URI of the created resource"
  value       = google_compute_forwarding_rule.this.self_link
}

output "ip_address" {
  description = "The IP address that will be used by this forwarding rule"
  value       = google_compute_forwarding_rule.this.ip_address
}