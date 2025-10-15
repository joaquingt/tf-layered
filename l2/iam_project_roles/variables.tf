variable "project_id" {
  description = "The ID of the project to apply IAM bindings to"
  type        = string
}

variable "project_roles" {
  description = "Map of roles to lists of members"
  type        = map(list(string))
  default     = {}
  
  validation {
    condition = alltrue([
      for role, members in var.project_roles : 
      can(regex("^roles/", role))
    ])
    error_message = "All roles must start with 'roles/'."
  }
  
  validation {
    condition = alltrue([
      for role, members in var.project_roles :
      alltrue([
        for member in members :
        can(regex("^(user:|serviceAccount:|group:|domain:)", member))
      ])
    ])
    error_message = "All members must be prefixed with user:, serviceAccount:, group:, or domain:."
  }
}