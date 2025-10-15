terraform {
  required_version = ">= 1.0"
  
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 4.0"
    }
  }
}

# Configure the Google Cloud Provider using environment variables
provider "google" {
  # Credentials will be loaded from GOOGLE_APPLICATION_CREDENTIALS env var
  # or from gcloud default credentials
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
    purpose     = "vm-deployment"
    managed-by  = "terraform"
  }
}

# Create basic VPC infrastructure
module "vpc_basic" {
  source = "../../../l2/vpc_basic"
  
  vpc_name   = "${var.project_id}-vpc"
  project_id = module.project_bootstrap.project_id
  region     = var.region
  
  subnet_cidr                  = var.subnet_cidr
  enable_private_google_access = true
  enable_ssh_access           = true
  enable_http_access          = false
  
  ssh_source_ranges = var.ssh_source_ranges
  
  depends_on = [module.project_bootstrap]
}

# Create free tier VM
module "vm_free_tier" {
  source = "../../../l2/vm_free_tier"
  
  instance_name = "${var.project_id}-vm"
  project_id    = module.project_bootstrap.project_id
  zone          = var.zone
  
  network    = module.vpc_basic.vpc_self_link
  subnetwork = module.vpc_basic.subnet_self_link
  
  enable_external_ip  = var.enable_external_ip
  create_external_ip  = var.create_static_ip
  
  boot_disk_image = var.boot_disk_image
  boot_disk_size  = var.boot_disk_size
  
  service_account_email = module.project_bootstrap.service_account_email
  
  tags = ["ssh", "dev-vm"]
  
  labels = {
    environment = "dev"
    tier        = "free"
    purpose     = "development"
  }
  
  startup_script = var.startup_script
  ssh_keys       = var.ssh_keys
  
  depends_on = [module.vpc_basic]
}