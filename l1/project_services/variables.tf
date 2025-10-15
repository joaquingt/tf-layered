variable "project_id" {
  description = "The ID of the project to enable services for"
  type        = string
}

variable "services" {
  description = "List of services to enable"
  type        = list(string)
}

variable "disable_dependent_services" {
  description = "Whether to disable dependent services when disabling this service"
  type        = bool
  default     = false
}

variable "disable_on_destroy" {
  description = "Whether to disable the service when the resource is destroyed"
  type        = bool
  default     = false
}