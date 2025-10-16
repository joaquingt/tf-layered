terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 4.0"
    }
  }
}

resource "google_compute_instance_group" "this" {
  name        = var.name
  project     = var.project_id
  zone        = var.zone
  description = var.description
  
  instances = var.instances
  
  dynamic "named_port" {
    for_each = var.named_ports
    content {
      name = named_port.value.name
      port = named_port.value.port
    }
  }
  
  network = var.network
}