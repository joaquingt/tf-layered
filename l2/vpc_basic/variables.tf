variable "vpc_name" {
  description = "Name of the VPC network"
  type        = string
  
  validation {
    condition     = can(regex("^[a-z][a-z0-9-]{1,61}[a-z0-9]$", var.vpc_name))
    error_message = "VPC name must be 1-63 characters long, start with a lowercase letter, and contain only lowercase letters, numbers, and hyphens."
  }
}

variable "project_id" {
  description = "The ID of the project where this VPC will be created"
  type        = string
}

variable "region" {
  description = "The GCP region where the subnet will be created"
  type        = string
  default     = "us-central1"
}

variable "subnet_name" {
  description = "Name of the subnet"
  type        = string
  default     = null
}

variable "subnet_cidr" {
  description = "The CIDR range for the subnet"
  type        = string
  default     = "10.0.0.0/24"
  
  validation {
    condition     = can(cidrhost(var.subnet_cidr, 0))
    error_message = "The subnet_cidr must be a valid CIDR block."
  }
}

variable "routing_mode" {
  description = "The network-wide routing mode to use"
  type        = string
  default     = "REGIONAL"
  
  validation {
    condition     = contains(["REGIONAL", "GLOBAL"], var.routing_mode)
    error_message = "Routing mode must be either REGIONAL or GLOBAL."
  }
}

variable "enable_private_google_access" {
  description = "Enable private Google access for the subnet"
  type        = bool
  default     = true
}

variable "secondary_ranges" {
  description = "List of secondary IP ranges for the subnet"
  type = list(object({
    range_name    = string
    ip_cidr_range = string
  }))
  default = []
}

variable "enable_ssh_access" {
  description = "Whether to create SSH firewall rule"
  type        = bool
  default     = true
}

variable "ssh_source_ranges" {
  description = "Source IP ranges that are allowed to SSH"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "enable_http_access" {
  description = "Whether to create HTTP/HTTPS firewall rule"
  type        = bool
  default     = false
}