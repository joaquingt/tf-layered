variable "name" {
  description = "Name of the backend service"
  type        = string
}

variable "project_id" {
  description = "The ID of the project in which the resource belongs"
  type        = string
}

variable "region" {
  description = "The region where the regional backend service resides"
  type        = string
}

variable "description" {
  description = "An optional description of this resource"
  type        = string
  default     = null
}

variable "protocol" {
  description = "The protocol this backend service uses to communicate with backends"
  type        = string
  default     = "TCP"
  
  validation {
    condition     = contains(["HTTP", "HTTPS", "HTTP2", "TCP", "SSL"], var.protocol)
    error_message = "Protocol must be one of: HTTP, HTTPS, HTTP2, TCP, SSL."
  }
}

variable "port_name" {
  description = "Name of backend port"
  type        = string
  default     = null
}

variable "timeout_sec" {
  description = "How many seconds to wait for the backend before considering it a failed request"
  type        = number
  default     = 30
  
  validation {
    condition     = var.timeout_sec >= 1 && var.timeout_sec <= 86400
    error_message = "Timeout must be between 1 and 86400 seconds."
  }
}

variable "health_checks" {
  description = "The set of URLs to the health check objects for this service"
  type        = list(string)
  default     = []
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

variable "affinity_cookie_ttl_sec" {
  description = "Lifetime of cookies in seconds if session_affinity is GENERATED_COOKIE"
  type        = number
  default     = null
}

variable "load_balancing_scheme" {
  description = "Indicates whether the backend service will be used with internal or external load balancing"
  type        = string
  default     = "INTERNAL"
  
  validation {
    condition     = contains(["INTERNAL", "EXTERNAL"], var.load_balancing_scheme)
    error_message = "Load balancing scheme must be either INTERNAL or EXTERNAL."
  }
}

variable "backends" {
  description = "The set of backends that serve this backend service"
  type = list(object({
    group                        = string
    balancing_mode              = optional(string, "CONNECTION")
    capacity_scaler             = optional(number, 1.0)
    description                 = optional(string)
    max_connections             = optional(number)
    max_connections_per_instance = optional(number)
    max_connections_per_endpoint = optional(number)
    max_rate                    = optional(number)
    max_rate_per_instance       = optional(number)
    max_rate_per_endpoint       = optional(number)
    max_utilization             = optional(number)
  }))
  default = []
}

variable "connection_draining_timeout_sec" {
  description = "Time for which instance will be drained"
  type        = number
  default     = null
}