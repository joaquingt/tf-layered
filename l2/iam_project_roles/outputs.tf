output "applied_roles" {
  description = "Map of roles and their members that were applied"
  value = {
    for role in keys(var.project_roles) :
    role => module.project_roles[role].members
  }
}