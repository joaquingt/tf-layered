variable "account_id" {
  description = "The account id that is used to generate the service account email address"
  type        = string
}

variable "project_id" {
  description = "The ID of the project that the service account will be created in"
  type        = string
}

variable "display_name" {
  description = "The display name for the service account"
  type        = string
  default     = null
}

variable "description" {
  description = "A text description of the service account"
  type        = string
  default     = null
}