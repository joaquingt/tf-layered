output "project_id" {
  description = "The ID of the created project"
  value       = google_project.this.project_id
}

output "name" {
  description = "The display name of the project"
  value       = google_project.this.name
}

output "number" {
  description = "The numeric identifier of the project"
  value       = google_project.this.number
}