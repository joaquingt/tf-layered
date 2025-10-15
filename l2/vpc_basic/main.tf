terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 4.0"
    }
  }
}

# Create VPC
module "vpc" {
  source = "../../l1/vpc"
  
  name                    = var.vpc_name
  project_id              = var.project_id
  auto_create_subnetworks = false
  routing_mode            = var.routing_mode
  description             = "VPC created by vpc_basic module"
}

# Create subnet
module "subnet" {
  source = "../../l1/subnet"
  
  name                     = var.subnet_name != null ? var.subnet_name : "${var.vpc_name}-subnet"
  project_id               = var.project_id
  region                   = var.region
  network                  = module.vpc.name
  ip_cidr_range            = var.subnet_cidr
  private_ip_google_access = var.enable_private_google_access
  description              = "Subnet created by vpc_basic module"
  
  secondary_ip_ranges = var.secondary_ranges
}

# Create basic firewall rules
module "allow_internal" {
  source = "../../l1/firewall_rule"
  
  name         = "${var.vpc_name}-allow-internal"
  project_id   = var.project_id
  network      = module.vpc.name
  direction    = "INGRESS"
  priority     = 1000
  description  = "Allow internal traffic"
  
  source_ranges = [var.subnet_cidr]
  
  allow_rules = [
    {
      protocol = "tcp"
      ports    = null
    },
    {
      protocol = "udp" 
      ports    = null
    },
    {
      protocol = "icmp"
      ports    = null
    }
  ]
}

module "allow_ssh" {
  count = var.enable_ssh_access ? 1 : 0
  
  source = "../../l1/firewall_rule"
  
  name         = "${var.vpc_name}-allow-ssh"
  project_id   = var.project_id
  network      = module.vpc.name
  direction    = "INGRESS"
  priority     = 1000
  description  = "Allow SSH access"
  
  source_ranges = var.ssh_source_ranges
  target_tags   = ["ssh"]
  
  allow_rules = [
    {
      protocol = "tcp"
      ports    = ["22"]
    }
  ]
}

module "allow_http_https" {
  count = var.enable_http_access ? 1 : 0
  
  source = "../../l1/firewall_rule"
  
  name         = "${var.vpc_name}-allow-http-https"
  project_id   = var.project_id
  network      = module.vpc.name
  direction    = "INGRESS"
  priority     = 1000
  description  = "Allow HTTP and HTTPS access"
  
  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["http-server", "https-server"]
  
  allow_rules = [
    {
      protocol = "tcp"
      ports    = ["80", "443"]
    }
  ]
}