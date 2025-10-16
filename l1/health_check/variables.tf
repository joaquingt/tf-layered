variable "name" {
  description = "Name of the health check"
  type        = string
}

variable "project_id" {
  description = "The ID of the project in which the resource belongs"
  type        = string
}

variable "description" {
  description = "An optional description of this resource"
  type        = string
  default     = null
}

variable "timeout_sec" {
  description = "How long (in seconds) to wait before claiming failure"
  type        = number
  default     = 5
  
  validation {
    condition     = var.timeout_sec >= 1 && var.timeout_sec <= 300
    error_message = "Timeout must be between 1 and 300 seconds."
  }
}

variable "check_interval_sec" {
  description = "How often (in seconds) to send a health check"
  type        = number
  default     = 5
  
  validation {
    condition     = var.check_interval_sec >= 1 && var.check_interval_sec <= 300
    error_message = "Check interval must be between 1 and 300 seconds."
  }
}

variable "healthy_threshold" {
  description = "A so-far unhealthy instance will be marked healthy after this many consecutive successes"
  type        = number
  default     = 2
  
  validation {
    condition     = var.healthy_threshold >= 1 && var.healthy_threshold <= 10
    error_message = "Healthy threshold must be between 1 and 10."
  }
}

variable "unhealthy_threshold" {
  description = "A so-far healthy instance will be marked unhealthy after this many consecutive failures"
  type        = number
  default     = 3
  
  validation {
    condition     = var.unhealthy_threshold >= 1 && var.unhealthy_threshold <= 10
    error_message = "Unhealthy threshold must be between 1 and 10."
  }
}

variable "http_health_check" {
  description = "HTTP health check configuration"
  type = object({
    port               = optional(number)
    port_name          = optional(string)
    port_specification = optional(string)
    host               = optional(string)
    request_path       = optional(string)
    proxy_header       = optional(string)
    response           = optional(string)
  })
  default = null
}

variable "https_health_check" {
  description = "HTTPS health check configuration"
  type = object({
    port               = optional(number)
    port_name          = optional(string)
    port_specification = optional(string)
    host               = optional(string)
    request_path       = optional(string)
    proxy_header       = optional(string)
    response           = optional(string)
  })
  default = null
}

variable "tcp_health_check" {
  description = "TCP health check configuration"
  type = object({
    port               = optional(number)
    port_name          = optional(string)
    port_specification = optional(string)
    proxy_header       = optional(string)
    request            = optional(string)
    response           = optional(string)
  })
  default = null
}