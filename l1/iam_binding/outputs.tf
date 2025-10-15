output "role" {
  description = "The role that was applied"
  value       = google_project_iam_binding.this.role
}

output "members" {
  description = "The members that were granted the role"
  value       = google_project_iam_binding.this.members
}