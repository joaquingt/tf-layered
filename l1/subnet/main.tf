terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 4.0"
    }
  }
}

resource "google_compute_subnetwork" "this" {
  name          = var.name
  project       = var.project_id
  region        = var.region
  network       = var.network
  ip_cidr_range = var.ip_cidr_range
  description   = var.description
  
  private_ip_google_access = var.private_ip_google_access
  
  dynamic "secondary_ip_range" {
    for_each = var.secondary_ip_ranges
    content {
      range_name    = secondary_ip_range.value.range_name
      ip_cidr_range = secondary_ip_range.value.ip_cidr_range
    }
  }
}