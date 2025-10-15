terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 4.0"
    }
  }
}

# Create the project
module "project" {
  source = "../../l1/project"
  
  name            = var.project_name
  project_id      = var.project_id
  folder_id       = var.folder_id
  org_id          = var.org_id
  billing_account = var.skip_billing ? null : var.billing_account
  
  auto_create_network = false
  labels = merge(var.labels, {
    managed-by = "terraform"
    layer      = "l2-bootstrap"
  })
}

# Enable required APIs
module "project_services" {
  source = "../../l1/project_services"
  
  project_id = module.project.project_id
  services   = var.apis_to_enable
  
  disable_on_destroy = false
  
  depends_on = [module.project]
}

# Create service account for the project
module "default_service_account" {
  source = "../../l1/service_account"
  
  project_id   = module.project.project_id
  account_id   = "${var.project_id}-sa"
  display_name = "Default Service Account for ${var.project_name}"
  description  = "Service account created by project bootstrap"
  
  depends_on = [module.project_services]
}

# Basic IAM binding for the service account
module "sa_iam" {
  source = "../../l1/iam_binding"
  
  project_id = module.project.project_id
  role       = "roles/editor"
  members    = ["serviceAccount:${module.default_service_account.email}"]
  
  depends_on = [module.default_service_account]
}