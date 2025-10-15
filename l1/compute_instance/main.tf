terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 4.0"
    }
  }
}

resource "google_compute_instance" "this" {
  name         = var.name
  project      = var.project_id
  zone         = var.zone
  machine_type = var.machine_type
  description  = var.description
  
  tags = var.tags
  labels = var.labels
  
  boot_disk {
    initialize_params {
      image = var.boot_disk_image
      size  = var.boot_disk_size
      type  = var.boot_disk_type
    }
  }
  
  dynamic "attached_disk" {
    for_each = var.additional_disks
    content {
      source      = attached_disk.value.source
      device_name = attached_disk.value.device_name
    }
  }
  
  network_interface {
    network    = var.network
    subnetwork = var.subnetwork
    
    dynamic "access_config" {
      for_each = var.enable_external_ip ? [1] : []
      content {
        # Ephemeral IP
      }
    }
  }
  
  service_account {
    email  = var.service_account_email
    scopes = var.service_account_scopes
  }
  
  metadata_startup_script = var.startup_script
  metadata = var.metadata
}