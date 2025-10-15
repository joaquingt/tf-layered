variable "name" {
  description = "Name of the subnet"
  type        = string
}

variable "project_id" {
  description = "The ID of the project where this subnet will be created"
  type        = string
}

variable "region" {
  description = "The GCP region where the subnet will be created"
  type        = string
}

variable "network" {
  description = "The VPC network where this subnet will be created"
  type        = string
}

variable "ip_cidr_range" {
  description = "The range of internal addresses that are owned by this subnetwork"
  type        = string
}

variable "description" {
  description = "An optional description of the subnet"
  type        = string
  default     = null
}

variable "private_ip_google_access" {
  description = "When enabled, VMs in this subnetwork without external IP addresses can access Google APIs"
  type        = bool
  default     = false
}

variable "secondary_ip_ranges" {
  description = "List of secondary IP ranges for this subnetwork"
  type = list(object({
    range_name    = string
    ip_cidr_range = string
  }))
  default = []
}