terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 4.0"
    }
  }
}

resource "google_compute_health_check" "this" {
  name        = var.name
  project     = var.project_id
  description = var.description
  
  timeout_sec         = var.timeout_sec
  check_interval_sec  = var.check_interval_sec
  healthy_threshold   = var.healthy_threshold
  unhealthy_threshold = var.unhealthy_threshold
  
  dynamic "http_health_check" {
    for_each = var.http_health_check != null ? [var.http_health_check] : []
    content {
      port               = http_health_check.value.port
      port_name          = http_health_check.value.port_name
      port_specification = http_health_check.value.port_specification
      host               = http_health_check.value.host
      request_path       = http_health_check.value.request_path
      proxy_header       = http_health_check.value.proxy_header
      response           = http_health_check.value.response
    }
  }
  
  dynamic "https_health_check" {
    for_each = var.https_health_check != null ? [var.https_health_check] : []
    content {
      port               = https_health_check.value.port
      port_name          = https_health_check.value.port_name
      port_specification = https_health_check.value.port_specification
      host               = https_health_check.value.host
      request_path       = https_health_check.value.request_path
      proxy_header       = https_health_check.value.proxy_header
      response           = https_health_check.value.response
    }
  }
  
  dynamic "tcp_health_check" {
    for_each = var.tcp_health_check != null ? [var.tcp_health_check] : []
    content {
      port               = tcp_health_check.value.port
      port_name          = tcp_health_check.value.port_name
      port_specification = tcp_health_check.value.port_specification
      proxy_header       = tcp_health_check.value.proxy_header
      request            = tcp_health_check.value.request
      response           = tcp_health_check.value.response
    }
  }
}