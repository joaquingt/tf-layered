variable "name" {
  description = "Name of the forwarding rule"
  type        = string
}

variable "project_id" {
  description = "The ID of the project in which the resource belongs"
  type        = string
}

variable "region" {
  description = "The region in which the forwarding rule should be created"
  type        = string
}

variable "description" {
  description = "An optional description of this resource"
  type        = string
  default     = null
}

variable "target" {
  description = "The URL of the target resource to receive the matched traffic"
  type        = string
  default     = null
}

variable "backend_service" {
  description = "A BackendService to receive the matched traffic"
  type        = string
  default     = null
}

variable "ip_address" {
  description = "The IP address that this forwarding rule serves"
  type        = string
  default     = null
}

variable "ip_protocol" {
  description = "The IP protocol to which this rule applies"
  type        = string
  default     = "TCP"
  
  validation {
    condition     = contains(["TCP", "UDP", "ESP", "AH", "SCTP", "ICMP"], var.ip_protocol)
    error_message = "IP protocol must be one of: TCP, UDP, ESP, AH, SCTP, ICMP."
  }
}

variable "load_balancing_scheme" {
  description = "This signifies what the forwarding rule will be used for"
  type        = string
  default     = "INTERNAL"
  
  validation {
    condition     = contains(["INTERNAL", "EXTERNAL"], var.load_balancing_scheme)
    error_message = "Load balancing scheme must be either INTERNAL or EXTERNAL."
  }
}

variable "network" {
  description = "The network that this rule applies to"
  type        = string
  default     = null
}

variable "subnetwork" {
  description = "The subnetwork that the load balanced IP should belong to"
  type        = string
  default     = null
}

variable "network_tier" {
  description = "The networking tier used for configuring this forwarding rule"
  type        = string
  default     = null
  
  validation {
    condition = var.network_tier == null || contains(["PREMIUM", "STANDARD"], var.network_tier)
    error_message = "Network tier must be either PREMIUM or STANDARD."
  }
}

variable "port_range" {
  description = "When the load balancing scheme is EXTERNAL, INTERNAL_SELF_MANAGED or INTERNAL_MANAGED, you can specify a port_range"
  type        = string
  default     = null
}

variable "ports" {
  description = "List of ports. Only packets addressed to these ports will be forwarded"
  type        = list(string)
  default     = null
}

variable "all_ports" {
  description = "For internal load balancing, this field identifies whether this forwarding rule will receive all ports or a list of ports"
  type        = bool
  default     = null
}

variable "allow_global_access" {
  description = "If true, clients can access ILB from all regions"
  type        = bool
  default     = false
}

variable "is_mirroring_collector" {
  description = "Indicates whether or not this load balancer can be used as a collector for packet mirroring"
  type        = bool
  default     = false
}

variable "labels" {
  description = "Labels to apply to this forwarding rule"
  type        = map(string)
  default     = {}
}