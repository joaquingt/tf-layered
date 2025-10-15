terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 4.0"
    }
  }
}

resource "google_service_account" "this" {
  account_id   = var.account_id
  project      = var.project_id
  display_name = var.display_name
  description  = var.description
}