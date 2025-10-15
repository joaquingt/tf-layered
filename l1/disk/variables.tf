variable "name" {
  description = "Name of the resource"
  type        = string
}

variable "project_id" {
  description = "The ID of the project in which the resource belongs"
  type        = string
}

variable "zone" {
  description = "A reference to the zone where the disk resides"
  type        = string
}

variable "type" {
  description = "URL of the disk type resource describing which disk type to use to create the disk"
  type        = string
  default     = "pd-standard"
}

variable "size" {
  description = "Size of the persistent disk, specified in GB"
  type        = number
  default     = 10
}

variable "image" {
  description = "The image from which to initialize this disk"
  type        = string
  default     = null
}

variable "labels" {
  description = "Labels to apply to this disk"
  type        = map(string)
  default     = {}
}