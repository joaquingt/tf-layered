terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 4.0"
    }
  }
}

resource "google_compute_disk" "this" {
  name    = var.name
  project = var.project_id
  zone    = var.zone
  type    = var.type
  size    = var.size
  image   = var.image
  labels  = var.labels
}