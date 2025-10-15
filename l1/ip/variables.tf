variable "name" {
  description = "Name of the resource"
  type        = string
}

variable "project_id" {
  description = "The ID of the project in which the resource belongs"
  type        = string
}

variable "region" {
  description = "The Region in which the created address should reside"
  type        = string
}

variable "address_type" {
  description = "The type of address to reserve"
  type        = string
  default     = "EXTERNAL"
  validation {
    condition     = contains(["INTERNAL", "EXTERNAL"], var.address_type)
    error_message = "Address type must be either INTERNAL or EXTERNAL."
  }
}

variable "purpose" {
  description = "The purpose of this resource"
  type        = string
  default     = null
}

variable "subnetwork" {
  description = "The URL of the subnetwork in which to reserve the address"
  type        = string
  default     = null
}