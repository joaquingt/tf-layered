output "email" {
  description = "The email address of the service account"
  value       = google_service_account.this.email
}

output "id" {
  description = "The ID of the service account"
  value       = google_service_account.this.id
}

output "unique_id" {
  description = "The unique id of the service account"
  value       = google_service_account.this.unique_id
}