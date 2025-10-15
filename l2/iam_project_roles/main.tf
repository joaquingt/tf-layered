terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 4.0"
    }
  }
}

# Create IAM bindings for project roles
module "project_roles" {
  source = "../../l1/iam_binding"
  
  for_each = var.project_roles
  
  project_id = var.project_id
  role       = each.key
  members    = each.value
}