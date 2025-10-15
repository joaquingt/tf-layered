variable "name" {
  description = "Name of the VPC network"
  type        = string
}

variable "project_id" {
  description = "The ID of the project where this VPC will be created"
  type        = string
}

variable "auto_create_subnetworks" {
  description = "Whether to automatically create subnetworks"
  type        = bool
  default     = false
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

variable "mtu" {
  description = "Maximum Transmission Unit in bytes"
  type        = number
  default     = 1460
}

variable "description" {
  description = "An optional description of the network"
  type        = string
  default     = null
}