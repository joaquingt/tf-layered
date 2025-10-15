output "name" {
  description = "Name of the disk"
  value       = google_compute_disk.this.name
}

output "id" {
  description = "The unique identifier for the resource"
  value       = google_compute_disk.this.id
}

output "self_link" {
  description = "The URI of the created resource"
  value       = google_compute_disk.this.self_link
}