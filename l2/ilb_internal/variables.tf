variable "name" {
  description = "Base name for the internal load balancer resources"
  type        = string
  
  validation {
    condition     = can(regex("^[a-z][a-z0-9-]{1,61}[a-z0-9]$", var.name))
    error_message = "Name must be 1-63 characters long, start with a lowercase letter, and contain only lowercase letters, numbers, and hyphens."
  }
}

variable "project_id" {
  description = "The project ID where resources will be created"
  type        = string
}

variable "region" {
  description = "The region where the load balancer will be created"
  type        = string
}

variable "network" {
  description = "The VPC network where the load balancer will be created"
  type        = string
}

variable "subnetwork" {
  description = "The subnetwork where the load balancer will be created"
  type        = string
}

variable "protocol" {
  description = "The protocol for the backend service"
  type        = string
  default     = "TCP"
  
  validation {
    condition     = contains(["HTTP", "HTTPS", "HTTP2", "TCP", "SSL"], var.protocol)
    error_message = "Protocol must be one of: HTTP, HTTPS, HTTP2, TCP, SSL."
  }
}

variable "port" {
  description = "The port number for the backend service"
  type        = number
  default     = 80
  
  validation {
    condition     = var.port >= 1 && var.port <= 65535
    error_message = "Port must be between 1 and 65535."
  }
}

variable "port_name" {
  description = "The name of the port for the backend service"
  type        = string
  default     = "http"
}

variable "instance_groups" {
  description = "Map of instance groups with their configurations"
  type = map(object({
    zone      = string
    instances = list(string)
  }))
}

variable "health_check_config" {
  description = "Health check configuration"
  type = object({
    timeout_sec         = optional(number, 5)
    check_interval_sec  = optional(number, 5)
    healthy_threshold   = optional(number, 2)
    unhealthy_threshold = optional(number, 3)
    port                = optional(number)
    port_name           = optional(string)
    port_specification  = optional(string, "USE_NAMED_PORT")
    host                = optional(string)
    request_path        = optional(string, "/")
    proxy_header        = optional(string, "NONE")
    response            = optional(string)
    request             = optional(string)
  })
  default = {}
}

variable "timeout_sec" {
  description = "Backend service timeout in seconds"
  type        = number
  default     = 30
  
  validation {
    condition     = var.timeout_sec >= 1 && var.timeout_sec <= 86400
    error_message = "Timeout must be between 1 and 86400 seconds."
  }
}

variable "session_affinity" {
  description = "Type of session affinity to use"
  type        = string
  default     = "NONE"
  
  validation {
    condition     = contains(["NONE", "CLIENT_IP", "CLIENT_IP_PROTO", "CLIENT_IP_PORT_PROTO"], var.session_affinity)
    error_message = "Session affinity must be one of: NONE, CLIENT_IP, CLIENT_IP_PROTO, CLIENT_IP_PORT_PROTO."
  }
}

variable "balancing_mode" {
  description = "Balancing mode for backends"
  type        = string
  default     = "CONNECTION"
  
  validation {
    condition     = contains(["CONNECTION", "RATE", "UTILIZATION"], var.balancing_mode)
    error_message = "Balancing mode must be one of: CONNECTION, RATE, UTILIZATION."
  }
}

variable "capacity_scaler" {
  description = "A multiplier applied to the group's max serving capacity"
  type        = number
  default     = 1.0
  
  validation {
    condition     = var.capacity_scaler >= 0.0 && var.capacity_scaler <= 1.0
    error_message = "Capacity scaler must be between 0.0 and 1.0."
  }
}

variable "max_connections" {
  description = "Maximum number of concurrent connections that the backend can handle"
  type        = number
  default     = null
}

variable "max_connections_per_instance" {
  description = "Maximum number of concurrent connections per instance"
  type        = number
  default     = null
}

variable "max_rate" {
  description = "Maximum rate (requests per second) that the backend can handle"
  type        = number
  default     = null
}

variable "max_rate_per_instance" {
  description = "Maximum rate per instance"
  type        = number
  default     = null
}

variable "max_utilization" {
  description = "Used when balancing_mode is UTILIZATION"
  type        = number
  default     = null
  
  validation {
    condition = var.max_utilization == null || (var.max_utilization >= 0.0 && var.max_utilization <= 1.0)
    error_message = "Max utilization must be between 0.0 and 1.0."
  }
}

variable "connection_draining_timeout_sec" {
  description = "Time for which instance will be drained"
  type        = number
  default     = 300
}

variable "create_static_ip" {
  description = "Whether to create a static internal IP address"
  type        = bool
  default     = false
}

variable "ip_address" {
  description = "IP address for the forwarding rule (if not using static IP)"
  type        = string
  default     = null
}

variable "ip_protocol" {
  description = "The IP protocol for the forwarding rule"
  type        = string
  default     = "TCP"
  
  validation {
    condition     = contains(["TCP", "UDP", "ESP", "AH", "SCTP", "ICMP"], var.ip_protocol)
    error_message = "IP protocol must be one of: TCP, UDP, ESP, AH, SCTP, ICMP."
  }
}

variable "port_range" {
  description = "Port range for the forwarding rule"
  type        = string
  default     = null
}

variable "ports" {
  description = "List of ports for the forwarding rule"
  type        = list(string)
  default     = null
}

variable "all_ports" {
  description = "Whether the forwarding rule should handle all ports"
  type        = bool
  default     = null
}

variable "allow_global_access" {
  description = "Whether to allow global access to the load balancer"
  type        = bool
  default     = false
}

variable "labels" {
  description = "Labels to apply to resources"
  type        = map(string)
  default = {
    environment = "dev"
    purpose     = "load-balancer"
  }
}