terraform {
  required_version = ">= 1.0"
  
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 4.0"
    }
  }
}

# Configure the Google Cloud Provider
provider "google" {
  project = var.google_project != "" ? var.google_project : var.project_id
  region  = var.google_region
}

# Create and bootstrap a new GCP project
module "project_bootstrap" {
  source = "../../../l2/project_bootstrap"
  
  project_name    = var.project_name
  project_id      = var.project_id
  folder_id       = var.folder_id
  org_id          = var.org_id
  billing_account = var.billing_account
  skip_billing    = var.skip_billing
  
  apis_to_enable = [
    "compute.googleapis.com",
    "storage.googleapis.com",
    "iam.googleapis.com",
    "serviceusage.googleapis.com",
    "cloudresourcemanager.googleapis.com"
  ]
  
  labels = {
    environment = "dev"
    layer       = "l3-consumer"
    purpose     = "ilb-deployment"
    managed-by  = "terraform"
  }
}

# Create VPC infrastructure
module "vpc_basic" {
  source = "../../../l2/vpc_basic"
  
  vpc_name   = "${var.project_id}-vpc"
  project_id = module.project_bootstrap.project_id
  region     = var.region
  
  subnet_cidr                  = var.subnet_cidr
  enable_private_google_access = true
  enable_ssh_access           = true
  enable_http_access          = true
  
  ssh_source_ranges = var.ssh_source_ranges
  
  depends_on = [module.project_bootstrap]
}

# Create backend VMs that will be behind the load balancer
module "backend_vms" {
  source = "../../../l2/vm_free_tier"
  
  count = var.backend_vm_count
  
  instance_name = "${var.project_id}-backend-${count.index + 1}"
  project_id    = module.project_bootstrap.project_id
  zone          = element(var.zones, count.index)
  
  network    = module.vpc_basic.vpc_self_link
  subnetwork = module.vpc_basic.subnet_self_link
  
  enable_external_ip = false  # Internal only for load balancer backends
  
  boot_disk_image = var.boot_disk_image
  boot_disk_size  = var.boot_disk_size
  
  service_account_email = module.project_bootstrap.service_account_email
  
  tags = ["backend-vm", "http-server"]
  
  labels = {
    environment = "dev"
    tier        = "free"
    purpose     = "backend"
    role        = "web-server"
  }
  
  # Install and configure a simple web server
  startup_script = templatefile("${path.module}/startup-script.sh", {
    server_id = count.index + 1
    port      = var.backend_port
  })
  
  depends_on = [module.vpc_basic]
}

# Create Internal Load Balancer
module "internal_lb" {
  source = "../../../l2/ilb_internal"
  
  name       = "${var.project_id}-ilb"
  project_id = module.project_bootstrap.project_id
  region     = var.region
  
  network    = module.vpc_basic.vpc_self_link
  subnetwork = module.vpc_basic.subnet_self_link
  
  protocol  = var.lb_protocol
  port      = var.backend_port
  port_name = var.port_name
  
  # Group instances by zone for instance groups
  instance_groups = {
    for zone in var.zones : zone => {
      zone = zone
      instances = [
        for vm in module.backend_vms : vm.instance_self_link
        if endswith(vm.instance_self_link, zone)
      ]
    }
  }
  
  health_check_config = {
    timeout_sec         = 5
    check_interval_sec  = 10
    healthy_threshold   = 2
    unhealthy_threshold = 3
    port               = var.backend_port
    request_path       = var.health_check_path
    host               = "localhost"
  }
  
  # Load balancer configuration
  session_affinity = var.session_affinity
  timeout_sec      = var.timeout_sec
  
  # Backend configuration
  balancing_mode              = "CONNECTION"
  max_connections_per_instance = var.max_connections_per_instance
  
  # Create static IP for the load balancer
  create_static_ip = var.create_static_ip
  
  # Allow global access for testing
  allow_global_access = var.allow_global_access
  
  labels = {
    environment = "dev"
    purpose     = "internal-load-balancer"
    protocol    = lower(var.lb_protocol)
  }
  
  depends_on = [module.backend_vms]
}

# Create a test VM to access the load balancer
module "test_vm" {
  count = var.create_test_vm ? 1 : 0
  
  source = "../../../l2/vm_free_tier"
  
  instance_name = "${var.project_id}-test-client"
  project_id    = module.project_bootstrap.project_id
  zone          = var.zones[0]
  
  network    = module.vpc_basic.vpc_self_link
  subnetwork = module.vpc_basic.subnet_self_link
  
  enable_external_ip = true  # Allow external access for testing
  
  service_account_email = module.project_bootstrap.service_account_email
  
  tags = ["test-client", "ssh"]
  
  labels = {
    environment = "dev"
    purpose     = "test-client"
  }
  
  startup_script = templatefile("${path.module}/test-client-startup.sh", {
    lb_ip = module.internal_lb.load_balancer_ip
    port  = var.backend_port
  })
  
  ssh_keys = var.ssh_keys
  
  depends_on = [module.internal_lb]
}