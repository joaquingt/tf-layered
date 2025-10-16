variable "name" {
  description = "The name of the instance group"
  type        = string
}

variable "project_id" {
  description = "The ID of the project in which the resource belongs"
  type        = string
}

variable "zone" {
  description = "The zone that this instance group should be created in"
  type        = string
}

variable "description" {
  description = "An optional textual description of the instance group"
  type        = string
  default     = null
}

variable "instances" {
  description = "List of instances in the group"
  type        = list(string)
  default     = []
}

variable "named_ports" {
  description = "The named port configuration"
  type = list(object({
    name = string
    port = number
  }))
  default = []
}

variable "network" {
  description = "The URL of the network the instance group is in"
  type        = string
  default     = null
}