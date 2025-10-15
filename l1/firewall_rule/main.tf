terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 4.0"
    }
  }
}

resource "google_compute_firewall" "this" {
  name        = var.name
  project     = var.project_id
  network     = var.network
  description = var.description
  direction   = var.direction
  priority    = var.priority
  
  source_ranges = var.source_ranges
  target_tags   = var.target_tags
  
  dynamic "allow" {
    for_each = var.allow_rules
    content {
      protocol = allow.value.protocol
      ports    = allow.value.ports
    }
  }
  
  dynamic "deny" {
    for_each = var.deny_rules
    content {
      protocol = deny.value.protocol
      ports    = deny.value.ports
    }
  }
}