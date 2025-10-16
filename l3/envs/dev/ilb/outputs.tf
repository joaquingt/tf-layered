output "project_info" {
  description = "Information about the created project"
  value = {
    project_id     = module.project_bootstrap.project_id
    project_number = module.project_bootstrap.project_number
  }
}

output "network_info" {
  description = "VPC network information"
  value = {
    vpc_name      = module.vpc_basic.vpc_name
    vpc_self_link = module.vpc_basic.vpc_self_link
    subnet_name   = module.vpc_basic.subnet_name
    subnet_cidr   = module.vpc_basic.subnet_cidr
  }
}

output "load_balancer_info" {
  description = "Internal Load Balancer information"
  value = {
    name               = module.internal_lb.forwarding_rule_name
    ip_address         = module.internal_lb.load_balancer_ip
    static_ip_address  = module.internal_lb.static_ip_address
    backend_service    = module.internal_lb.backend_service_name
    health_check       = module.internal_lb.health_check_name
    instance_groups    = module.internal_lb.instance_groups
  }
}

output "backend_vms" {
  description = "Information about backend VMs"
  value = [
    for vm in module.backend_vms : {
      name        = vm.instance_name
      zone        = vm.zone
      internal_ip = vm.internal_ip
      self_link   = vm.instance_self_link
    }
  ]
}

output "test_vm_info" {
  description = "Test VM information (if created)"
  value = var.create_test_vm ? {
    name        = module.test_vm[0].instance_name
    internal_ip = module.test_vm[0].internal_ip
    external_ip = module.test_vm[0].external_ip
    ssh_command = module.test_vm[0].ssh_command
  } : null
}

output "load_balancer_test_commands" {
  description = "Commands to test the load balancer"
  value = {
    from_test_vm = var.create_test_vm ? "curl http://${module.internal_lb.load_balancer_ip}:${var.backend_port}" : "No test VM created"
    health_check = "curl http://${module.internal_lb.load_balancer_ip}:${var.backend_port}${var.health_check_path}"
  }
}

output "service_account_email" {
  description = "Email of the created service account"
  value       = module.project_bootstrap.service_account_email
}

output "enabled_apis" {
  description = "List of enabled APIs in the project"
  value       = module.project_bootstrap.enabled_apis
}