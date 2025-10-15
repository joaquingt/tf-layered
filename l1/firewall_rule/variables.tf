variable "name" {
  description = "Name of the firewall rule"
  type        = string
}

variable "project_id" {
  description = "The ID of the project where this firewall rule will be created"
  type        = string
}

variable "network" {
  description = "The name or self_link of the network to attach this firewall to"
  type        = string
}

variable "description" {
  description = "An optional description of this resource"
  type        = string
  default     = null
}

variable "direction" {
  description = "Direction of traffic to which this firewall applies"
  type        = string
  default     = "INGRESS"
  validation {
    condition     = contains(["INGRESS", "EGRESS"], var.direction)
    error_message = "Direction must be either INGRESS or EGRESS."
  }
}

variable "priority" {
  description = "Priority for this rule"
  type        = number
  default     = 1000
}

variable "source_ranges" {
  description = "Source IP ranges that this firewall rule applies to"
  type        = list(string)
  default     = []
}

variable "target_tags" {
  description = "A list of instance tags indicating sets of instances located in the network"
  type        = list(string)
  default     = []
}

variable "allow_rules" {
  description = "List of allow rules"
  type = list(object({
    protocol = string
    ports    = optional(list(string))
  }))
  default = []
}

variable "deny_rules" {
  description = "List of deny rules"
  type = list(object({
    protocol = string
    ports    = optional(list(string))
  }))
  default = []
}