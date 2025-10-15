# Project Configuration
variable "project_name" {
  description = "The display name of the project to create"
  type        = string
}

variable "project_id" {
  description = "The unique ID of the project to create"
  type        = string
  
  validation {
    condition     = can(regex("^[a-z][a-z0-9-]{4,28}[a-z0-9]$", var.project_id))
    error_message = "Project ID must be 6-30 characters long, start with a lowercase letter, and contain only lowercase letters, numbers, and hyphens."
  }
}

variable "folder_id" {
  description = "The folder ID to create the project in (optional)"
  type        = string
  default     = null
}

variable "org_id" {
  description = "The organization ID to create the project in (required if no folder_id)"
  type        = string
  default     = null
}

variable "billing_account" {
  description = "The billing account to associate with the project"
  type        = string
  default     = null
}

variable "skip_billing" {
  description = "Whether to skip billing association (useful for testing)"
  type        = bool
  default     = false
}

# Environment Variables (for sensitive data)
variable "google_project" {
  description = "Default Google Cloud project from environment (GOOGLE_PROJECT)"
  type        = string
  default     = ""
  sensitive   = true
}

variable "google_region" {
  description = "Default Google Cloud region from environment (GOOGLE_REGION)"
  type        = string
  default     = "us-central1"
}

# Infrastructure Configuration
variable "region" {
  description = "The GCP region for resources"
  type        = string
  default     = "us-central1"
}

variable "zone" {
  description = "The GCP zone for the VM"
  type        = string
  default     = "us-central1-a"
}

variable "subnet_cidr" {
  description = "CIDR range for the subnet"
  type        = string
  default     = "10.0.0.0/24"
}

variable "ssh_source_ranges" {
  description = "Source IP ranges allowed for SSH access"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

# VM Configuration
variable "enable_external_ip" {
  description = "Whether to assign an external IP to the VM"
  type        = bool
  default     = true
}

variable "create_static_ip" {
  description = "Whether to create a static external IP"
  type        = bool
  default     = false
}

variable "boot_disk_image" {
  description = "Boot disk image for the VM"
  type        = string
  default     = "ubuntu-os-cloud/ubuntu-2004-lts"
}

variable "boot_disk_size" {
  description = "Boot disk size in GB (constrained to free tier: 10-30GB)"
  type        = number
  default     = 10
  
  validation {
    condition     = var.boot_disk_size >= 10 && var.boot_disk_size <= 30
    error_message = "Boot disk size must be between 10-30 GB to remain in free tier."
  }
}

variable "startup_script" {
  description = "Startup script for the VM"
  type        = string
  default     = <<-EOF
    #!/bin/bash
    apt-get update
    apt-get install -y nginx
    systemctl enable nginx
    systemctl start nginx
    echo "<h1>Welcome to $(hostname)</h1>" > /var/www/html/index.html
    EOF
}

variable "ssh_keys" {
  description = "SSH keys for VM access (format: username:ssh-rsa key)"
  type        = string
  default     = ""
}

# Environment variable mappings for Terraform Cloud/other CI systems
variable "gcp_credentials_json" {
  description = "GCP service account credentials as JSON string"
  type        = string
  default     = null
  sensitive   = true
}