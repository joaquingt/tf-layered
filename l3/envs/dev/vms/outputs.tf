output "project_id" {
  description = "ID of the created project"
  value       = module.project_bootstrap.project_id
}

output "project_number" {
  description = "Number of the created project"
  value       = module.project_bootstrap.project_number
}

output "vpc_info" {
  description = "VPC network information"
  value = {
    name      = module.vpc_basic.vpc_name
    id        = module.vpc_basic.vpc_id
    self_link = module.vpc_basic.vpc_self_link
  }
}

output "subnet_info" {
  description = "Subnet information"
  value = {
    name      = module.vpc_basic.subnet_name
    id        = module.vpc_basic.subnet_id
    self_link = module.vpc_basic.subnet_self_link
    cidr      = module.vpc_basic.subnet_cidr
  }
}

output "vm_info" {
  description = "VM instance information"
  value = {
    name        = module.vm_free_tier.instance_name
    id          = module.vm_free_tier.instance_id
    self_link   = module.vm_free_tier.instance_self_link
    internal_ip = module.vm_free_tier.internal_ip
    external_ip = module.vm_free_tier.external_ip
    static_ip   = module.vm_free_tier.static_ip
  }
}

output "ssh_command" {
  description = "SSH command to connect to the VM"
  value       = module.vm_free_tier.ssh_command
}

output "service_account_email" {
  description = "Email of the created service account"
  value       = module.project_bootstrap.service_account_email
}

output "enabled_apis" {
  description = "List of enabled APIs in the project"
  value       = module.project_bootstrap.enabled_apis
}