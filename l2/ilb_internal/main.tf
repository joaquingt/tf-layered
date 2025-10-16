terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 4.0"
    }
  }
}

# Create health check for the backend service
module "health_check" {
  source = "../../l1/health_check"
  
  name        = "${var.name}-health-check"
  project_id  = var.project_id
  description = "Health check for ${var.name} internal load balancer"
  
  timeout_sec         = var.health_check_config.timeout_sec
  check_interval_sec  = var.health_check_config.check_interval_sec
  healthy_threshold   = var.health_check_config.healthy_threshold
  unhealthy_threshold = var.health_check_config.unhealthy_threshold
  
  # Configure based on protocol
  http_health_check = var.protocol == "HTTP" ? {
    port               = var.health_check_config.port
    port_name          = var.health_check_config.port_name
    port_specification = var.health_check_config.port_specification
    host               = var.health_check_config.host
    request_path       = var.health_check_config.request_path
    proxy_header       = var.health_check_config.proxy_header
    response           = var.health_check_config.response
  } : null
  
  https_health_check = var.protocol == "HTTPS" ? {
    port               = var.health_check_config.port
    port_name          = var.health_check_config.port_name
    port_specification = var.health_check_config.port_specification
    host               = var.health_check_config.host
    request_path       = var.health_check_config.request_path
    proxy_header       = var.health_check_config.proxy_header
    response           = var.health_check_config.response
  } : null
  
  tcp_health_check = contains(["TCP", "SSL"], var.protocol) ? {
    port               = var.health_check_config.port
    port_name          = var.health_check_config.port_name
    port_specification = var.health_check_config.port_specification
    proxy_header       = var.health_check_config.proxy_header
    request            = var.health_check_config.request
    response           = var.health_check_config.response
  } : null
}

# Create instance groups for backend instances
module "instance_groups" {
  source = "../../l1/instance_group"
  
  for_each = var.instance_groups
  
  name        = "${var.name}-${each.key}"
  project_id  = var.project_id
  zone        = each.value.zone
  description = "Instance group ${each.key} for ${var.name} load balancer"
  
  instances = each.value.instances
  network   = var.network
  
  named_ports = [{
    name = var.port_name
    port = var.port
  }]
}

# Create backend service
module "backend_service" {
  source = "../../l1/backend_service"
  
  name        = "${var.name}-backend-service"
  project_id  = var.project_id
  region      = var.region
  description = "Backend service for ${var.name} internal load balancer"
  
  protocol              = var.protocol
  port_name             = var.port_name
  timeout_sec           = var.timeout_sec
  session_affinity      = var.session_affinity
  load_balancing_scheme = "INTERNAL"
  
  health_checks = [module.health_check.self_link]
  
  backends = [
    for key, group in module.instance_groups : {
      group                        = group.self_link
      balancing_mode              = var.balancing_mode
      capacity_scaler             = var.capacity_scaler
      description                 = "Backend for instance group ${key}"
      max_connections             = var.max_connections
      max_connections_per_instance = var.max_connections_per_instance
      max_rate                    = var.max_rate
      max_rate_per_instance       = var.max_rate_per_instance
      max_utilization             = var.max_utilization
    }
  ]
  
  connection_draining_timeout_sec = var.connection_draining_timeout_sec
}

# Optionally create static IP address
module "static_ip" {
  count = var.create_static_ip ? 1 : 0
  
  source = "../../l1/ip"
  
  name         = "${var.name}-ip"
  project_id   = var.project_id
  region       = var.region
  address_type = "INTERNAL"
  subnetwork   = var.subnetwork
}

# Create forwarding rule
module "forwarding_rule" {
  source = "../../l1/forwarding_rule"
  
  name        = "${var.name}-forwarding-rule"
  project_id  = var.project_id
  region      = var.region
  description = "Forwarding rule for ${var.name} internal load balancer"
  
  backend_service       = module.backend_service.self_link
  ip_address            = var.create_static_ip ? module.static_ip[0].address : var.ip_address
  ip_protocol           = var.ip_protocol
  load_balancing_scheme = "INTERNAL"
  network               = var.network
  subnetwork            = var.subnetwork
  port_range            = var.port_range
  ports                 = var.ports
  all_ports             = var.all_ports
  allow_global_access   = var.allow_global_access
  
  labels = merge(var.labels, {
    managed-by = "terraform"
    layer      = "l2-ilb-internal"
    purpose    = "internal-load-balancer"
  })
  
  depends_on = [module.backend_service]
}