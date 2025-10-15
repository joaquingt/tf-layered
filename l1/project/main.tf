terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 4.0"
    }
  }
}

resource "google_project" "this" {
  name            = var.name
  project_id      = var.project_id
  folder_id       = var.folder_id
  org_id          = var.org_id
  billing_account = var.billing_account
  
  auto_create_network = var.auto_create_network
  
  labels = var.labels
}