variable "name" {
  description = "The display name of the project"
  type        = string
}

variable "project_id" {
  description = "The ID of the project"
  type        = string
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

variable "auto_create_network" {
  description = "Whether to automatically create a default network"
  type        = bool
  default     = false
}

variable "labels" {
  description = "A map of labels to assign to the project"
  type        = map(string)
  default     = {}
}