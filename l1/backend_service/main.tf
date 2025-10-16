terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 4.0"
    }
  }
}

resource "google_compute_region_backend_service" "this" {
  name          = var.name
  project       = var.project_id
  region        = var.region
  description   = var.description
  protocol      = var.protocol
  port_name     = var.port_name
  timeout_sec   = var.timeout_sec
  
  health_checks         = var.health_checks
  session_affinity      = var.session_affinity
  affinity_cookie_ttl_sec = var.affinity_cookie_ttl_sec
  load_balancing_scheme = var.load_balancing_scheme
  
  dynamic "backend" {
    for_each = var.backends
    content {
      group                        = backend.value.group
      balancing_mode              = backend.value.balancing_mode
      capacity_scaler             = backend.value.capacity_scaler
      description                 = backend.value.description
      max_connections             = backend.value.max_connections
      max_connections_per_instance = backend.value.max_connections_per_instance
      max_connections_per_endpoint = backend.value.max_connections_per_endpoint
      max_rate                    = backend.value.max_rate
      max_rate_per_instance       = backend.value.max_rate_per_instance
      max_rate_per_endpoint       = backend.value.max_rate_per_endpoint
      max_utilization             = backend.value.max_utilization
    }
  }
  
  dynamic "connection_draining_timeout_sec" {
    for_each = var.connection_draining_timeout_sec != null ? [var.connection_draining_timeout_sec] : []
    content {
      connection_draining_timeout_sec = connection_draining_timeout_sec.value
    }
  }
}