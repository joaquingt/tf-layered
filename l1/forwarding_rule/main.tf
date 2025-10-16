terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 4.0"
    }
  }
}

resource "google_compute_forwarding_rule" "this" {
  name        = var.name
  project     = var.project_id
  region      = var.region
  description = var.description
  
  target                = var.target
  backend_service       = var.backend_service
  ip_address            = var.ip_address
  ip_protocol           = var.ip_protocol
  load_balancing_scheme = var.load_balancing_scheme
  network               = var.network
  subnetwork            = var.subnetwork
  network_tier          = var.network_tier
  port_range            = var.port_range
  ports                 = var.ports
  all_ports             = var.all_ports
  allow_global_access   = var.allow_global_access
  is_mirroring_collector = var.is_mirroring_collector
  
  labels = var.labels
}