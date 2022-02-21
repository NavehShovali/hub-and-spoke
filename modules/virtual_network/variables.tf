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
  description = "The subnets associated with the virtual network"
  type        = list(object({
    name                                           = string
    address_prefixes                               = list(string)
    enforce_private_link_endpoint_network_policies = bool
  }))
}
