variable "instance_name" {
  description = "Name of the VM instance"
  type        = string
  
  validation {
    condition     = can(regex("^[a-z][a-z0-9-]{1,61}[a-z0-9]$", var.instance_name))
    error_message = "Instance name must be 1-63 characters long, start with a lowercase letter, and contain only lowercase letters, numbers, and hyphens."
  }
}

variable "project_id" {
  description = "The ID of the project where this VM will be created"
  type        = string
}

variable "zone" {
  description = "The zone where the VM should be created"
  type        = string
  default     = "us-central1-a"
  
  validation {
    condition     = can(regex("^[a-z]+-[a-z0-9]+-[a-z]$", var.zone))
    error_message = "Zone must be a valid GCP zone format (e.g., us-central1-a)."
  }
}

variable "region" {
  description = "The region for regional resources"
  type        = string
  default     = "us-central1"
}

variable "network" {
  description = "The network to attach the VM to"
  type        = string
  default     = "default"
}

variable "subnetwork" {
  description = "The subnetwork to attach the VM to"
  type        = string
  default     = null
}

variable "enable_external_ip" {
  description = "Whether to assign an external IP to the VM"
  type        = bool
  default     = true
}

variable "create_external_ip" {
  description = "Whether to create a static external IP resource"
  type        = bool
  default     = false
}

variable "boot_disk_image" {
  description = "The image for the boot disk"
  type        = string
  default     = "ubuntu-os-cloud/ubuntu-2004-lts"
}

variable "boot_disk_size" {
  description = "Size of the boot disk in GB (max 30 for free tier)"
  type        = number
  default     = 10
  
  validation {
    condition     = var.boot_disk_size >= 10 && var.boot_disk_size <= 30
    error_message = "Boot disk size must be between 10-30 GB for free tier eligibility."
  }
}

variable "tags" {
  description = "Network tags to assign to the instance"
  type        = list(string)
  default     = ["ssh"]
}

variable "labels" {
  description = "Labels to assign to the instance"
  type        = map(string)
  default = {
    environment = "dev"
    tier        = "free"
  }
}

variable "service_account_email" {
  description = "The service account email to attach to the instance"
  type        = string
  default     = null
}

variable "service_account_scopes" {
  description = "The scopes to attach to the service account"
  type        = list(string)
  default     = ["cloud-platform"]
}

variable "startup_script" {
  description = "Startup script to run on the instance"
  type        = string
  default     = ""
}

variable "metadata" {
  description = "Metadata key/value pairs to make available from within the instance"
  type        = map(string)
  default     = {}
}

variable "ssh_keys" {
  description = "SSH keys for the instance (format: user:ssh-rsa key)"
  type        = string
  default     = ""
}