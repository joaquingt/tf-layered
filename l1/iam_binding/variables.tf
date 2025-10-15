variable "project_id" {
  description = "The ID of the project in which the role is granted"
  type        = string
}

variable "role" {
  description = "The role that should be applied"
  type        = string
}

variable "members" {
  description = "Identities that will be granted the privilege in role"
  type        = list(string)
}