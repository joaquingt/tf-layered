output "project_id" {
  description = "The ID of the created project"
  value       = module.project.project_id
}

output "project_number" {
  description = "The numeric identifier of the project"
  value       = module.project.number
}

output "enabled_apis" {
  description = "List of enabled APIs"
  value       = module.project_services.enabled_services
}

output "service_account_email" {
  description = "Email of the default service account"
  value       = module.default_service_account.email
}

output "service_account_id" {
  description = "ID of the default service account"
  value       = module.default_service_account.id
}