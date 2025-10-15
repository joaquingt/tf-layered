output "instance_name" {
  description = "Name of the VM instance"
  value       = module.vm_instance.name
}

output "instance_id" {
  description = "ID of the VM instance"
  value       = module.vm_instance.id
}

output "instance_self_link" {
  description = "Self link of the VM instance"
  value       = module.vm_instance.self_link
}

output "internal_ip" {
  description = "Internal IP address of the VM"
  value       = module.vm_instance.internal_ip
}

output "external_ip" {
  description = "External IP address of the VM"
  value       = module.vm_instance.external_ip
}

output "static_ip" {
  description = "Static external IP address if created"
  value       = var.create_external_ip ? module.external_ip[0].address : null
}

output "ssh_command" {
  description = "SSH command to connect to the instance"
  value       = module.vm_instance.external_ip != null ? "gcloud compute ssh ${module.vm_instance.name} --zone=${var.zone} --project=${var.project_id}" : "No external IP assigned"
}