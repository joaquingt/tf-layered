terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 4.0"
    }
  }
}

resource "google_project_iam_binding" "this" {
  project = var.project_id
  role    = var.role
  members = var.members
}