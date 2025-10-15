variable "project_name" {
  description = "The display name of the project"
  type        = string
}

variable "project_id" {
  description = "The ID of the project to create"
  type        = string
  
  validation {
    condition     = can(regex("^[a-z][a-z0-9-]{4,28}[a-z0-9]$", var.project_id))
    error_message = "Project ID must be 6-30 characters long, start with a lowercase letter, and contain only lowercase letters, numbers, and hyphens."
  }
}

variable "folder_id" {
  description = "The folder ID to place this project in"
  type        = string
  default     = null
}

variable "org_id" {
  description = "The organization ID to place this project in"
  type        = string
  default     = null
}

variable "billing_account" {
  description = "The billing account to associate with the project"
  type        = string
  default     = null
}

variable "skip_billing" {
  description = "Whether to skip billing association (useful for testing)"
  type        = bool
  default     = false
}

variable "apis_to_enable" {
  description = "List of APIs to enable for the project"
  type        = list(string)
  default = [
    "compute.googleapis.com",
    "storage.googleapis.com",
    "iam.googleapis.com",
    "serviceusage.googleapis.com"
  ]
}

variable "labels" {
  description = "A map of labels to assign to the project"
  type        = map(string)
  default = {
    environment = "dev"
    purpose     = "bootstrap"
  }
}

# Environment variables for sensitive data
variable "google_credentials" {
  description = "Path to Google Cloud credentials JSON file or JSON content"
  type        = string
  default     = null
  sensitive   = true
}

variable "google_project" {
  description = "Default Google Cloud project (from environment)"
  type        = string
  default     = null
}

variable "google_region" {
  description = "Default Google Cloud region (from environment)"
  type        = string
  default     = "us-central1"
}