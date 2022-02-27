variable "resource_group_name" {
  description = "Resource group to deploy to"
  type        = string
}

variable "location" {
  description = "Location to deploy to"
  type        = string
}

variable "name" {
  description = "The virtual network's name"
  type        = string
}

variable "address_space" {
  description = "The virtual network's address space"
  type        = list(string)
}

variable "subnets" {
  description = "The subnets associated with the virtual network. Maps subnet names to their definition"
  type        = map(object({
    address_prefixes                               = list(string)
    enforce_private_link_endpoint_network_policies = optional(bool)
  }))
}

variable "log_analytics_workspace_id" {
  description = "The ID of the log analytics workspace to save logs to"
  type        = string
}
