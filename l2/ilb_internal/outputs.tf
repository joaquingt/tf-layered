output "load_balancer_ip" {
  description = "The IP address of the internal load balancer"
  value       = module.forwarding_rule.ip_address
}

output "forwarding_rule_name" {
  description = "Name of the forwarding rule"
  value       = module.forwarding_rule.name
}

output "forwarding_rule_self_link" {
  description = "Self link of the forwarding rule"
  value       = module.forwarding_rule.self_link
}

output "backend_service_name" {
  description = "Name of the backend service"
  value       = module.backend_service.name
}

output "backend_service_self_link" {
  description = "Self link of the backend service"
  value       = module.backend_service.self_link
}

output "health_check_name" {
  description = "Name of the health check"
  value       = module.health_check.name
}

output "health_check_self_link" {
  description = "Self link of the health check"
  value       = module.health_check.self_link
}

output "instance_groups" {
  description = "Information about the created instance groups"
  value = {
    for key, group in module.instance_groups : key => {
      name      = group.name
      self_link = group.self_link
      size      = group.size
    }
  }
}

output "static_ip_address" {
  description = "The static IP address (if created)"
  value       = var.create_static_ip ? module.static_ip[0].address : null
}