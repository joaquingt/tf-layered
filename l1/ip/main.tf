terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 4.0"
    }
  }
}

resource "google_compute_address" "this" {
  name         = var.name
  project      = var.project_id
  region       = var.region
  address_type = var.address_type
  purpose      = var.purpose
  subnetwork   = var.subnetwork
}