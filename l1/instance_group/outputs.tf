output "name" {
  description = "The name of the instance group"
  value       = google_compute_instance_group.this.name
}

output "id" {
  description = "The unique identifier for the instance group"
  value       = google_compute_instance_group.this.id
}

output "self_link" {
  description = "The URI of the created resource"
  value       = google_compute_instance_group.this.self_link
}

output "size" {
  description = "The number of instances in the group"
  value       = google_compute_instance_group.this.size
}