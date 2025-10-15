terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 4.0"
    }
  }
}

# Create the VM instance constrained to free tier specs
module "vm_instance" {
  source = "../../l1/compute_instance"
  
  name         = var.instance_name
  project_id   = var.project_id
  zone         = var.zone
  machine_type = "e2-micro"  # Free tier eligible
  
  tags = concat(var.tags, ["free-tier"])
  labels = merge(var.labels, {
    tier        = "free"
    managed-by  = "terraform"
    layer       = "l2-vm-free-tier"
  })
  
  # Free tier constraints
  boot_disk_image = var.boot_disk_image
  boot_disk_size  = var.boot_disk_size <= 30 ? var.boot_disk_size : 30  # Max 30GB for free tier
  boot_disk_type  = "pd-standard"  # Standard persistent disk for free tier
  
  network        = var.network
  subnetwork     = var.subnetwork
  enable_external_ip = var.enable_external_ip
  
  service_account_email  = var.service_account_email
  service_account_scopes = var.service_account_scopes
  
  startup_script = var.startup_script
  metadata = merge(var.metadata, {
    startup-script = var.startup_script
    ssh-keys       = var.ssh_keys
  })
}

# Optional: Create external IP if requested
module "external_ip" {
  count = var.enable_external_ip && var.create_external_ip ? 1 : 0
  
  source = "../../l1/ip"
  
  name         = "${var.instance_name}-ip"
  project_id   = var.project_id
  region       = var.region
  address_type = "EXTERNAL"
}