output "enabled_services" {
  description = "List of enabled services"
  value       = [for service in google_project_service.this : service.service]
}