variable "name" {
  description = "Name of the instance"
  type        = string
}

variable "project_id" {
  description = "The ID of the project in which the resource belongs"
  type        = string
}

variable "zone" {
  description = "The zone that the machine should be created in"
  type        = string
}

variable "machine_type" {
  description = "The machine type to create"
  type        = string
  default     = "e2-micro"
}

variable "description" {
  description = "A brief description of this resource"
  type        = string
  default     = null
}

variable "tags" {
  description = "A list of network tags to attach to the instance"
  type        = list(string)
  default     = []
}

variable "labels" {
  description = "A map of key/value label pairs to assign to the instance"
  type        = map(string)
  default     = {}
}

variable "boot_disk_image" {
  description = "The image from which to initialize this disk"
  type        = string
  default     = "ubuntu-os-cloud/ubuntu-2004-lts"
}

variable "boot_disk_size" {
  description = "The size of the image in gigabytes"
  type        = number
  default     = 10
}

variable "boot_disk_type" {
  description = "The GCE disk type"
  type        = string
  default     = "pd-standard"
}

variable "additional_disks" {
  description = "List of additional disks to attach to the instance"
  type = list(object({
    source      = string
    device_name = string
  }))
  default = []
}

variable "network" {
  description = "The name or self_link of the network to attach this interface to"
  type        = string
  default     = "default"
}

variable "subnetwork" {
  description = "The name of the subnetwork to attach this interface to"
  type        = string
  default     = null
}

variable "enable_external_ip" {
  description = "Whether to enable external IP on the instance"
  type        = bool
  default     = false
}

variable "service_account_email" {
  description = "The service account e-mail address"
  type        = string
  default     = null
}

variable "service_account_scopes" {
  description = "A list of service scopes"
  type        = list(string)
  default     = ["cloud-platform"]
}

variable "startup_script" {
  description = "An alternative to using the startup-script metadata key"
  type        = string
  default     = null
}

variable "metadata" {
  description = "Metadata key/value pairs to make available from within the instance"
  type        = map(string)
  default     = {}
}