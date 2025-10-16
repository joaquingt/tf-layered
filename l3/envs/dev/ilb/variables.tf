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

# Environment Variables
variable "google_project" {
  description = "Default Google Cloud project from environment"
  type        = string
  default     = ""
  sensitive   = true
}

variable "google_region" {
  description = "Default Google Cloud region from environment"
  type        = string
  default     = "us-central1"
}

# Infrastructure Configuration
variable "region" {
  description = "The GCP region for resources"
  type        = string
  default     = "us-central1"
}

variable "zones" {
  description = "List of zones for backend VMs (for high availability)"
  type        = list(string)
  default     = ["us-central1-a", "us-central1-b"]
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

# Backend VM Configuration
variable "backend_vm_count" {
  description = "Number of backend VMs to create"
  type        = number
  default     = 2
  
  validation {
    condition     = var.backend_vm_count >= 1 && var.backend_vm_count <= 10
    error_message = "Backend VM count must be between 1 and 10."
  }
}

variable "boot_disk_image" {
  description = "Boot disk image for VMs"
  type        = string
  default     = "ubuntu-os-cloud/ubuntu-2004-lts"
}

variable "boot_disk_size" {
  description = "Boot disk size in GB"
  type        = number
  default     = 10
}

# Load Balancer Configuration
variable "lb_protocol" {
  description = "Protocol for the load balancer"
  type        = string
  default     = "HTTP"
  
  validation {
    condition     = contains(["HTTP", "HTTPS", "TCP", "SSL"], var.lb_protocol)
    error_message = "Protocol must be one of: HTTP, HTTPS, TCP, SSL."
  }
}

variable "backend_port" {
  description = "Port on which backend VMs serve traffic"
  type        = number
  default     = 80
}

variable "port_name" {
  description = "Named port for the load balancer"
  type        = string
  default     = "http"
}

variable "health_check_path" {
  description = "Path for HTTP health checks"
  type        = string
  default     = "/"
}

variable "session_affinity" {
  description = "Session affinity type"
  type        = string
  default     = "NONE"
}

variable "timeout_sec" {
  description = "Backend timeout in seconds"
  type        = number
  default     = 30
}

variable "max_connections_per_instance" {
  description = "Maximum connections per backend instance"
  type        = number
  default     = 1000
}

variable "create_static_ip" {
  description = "Whether to create a static internal IP for the load balancer"
  type        = bool
  default     = true
}

variable "allow_global_access" {
  description = "Whether to allow global access to the internal load balancer"
  type        = bool
  default     = false
}

# Test Configuration
variable "create_test_vm" {
  description = "Whether to create a test VM to access the load balancer"
  type        = bool
  default     = true
}

variable "ssh_keys" {
  description = "SSH keys for VM access (format: username:ssh-rsa key)"
  type        = string
  default     = ""
}

# Environment variable mappings
variable "gcp_credentials_json" {
  description = "GCP service account credentials as JSON string"
  type        = string
  default     = null
  sensitive   = true
}