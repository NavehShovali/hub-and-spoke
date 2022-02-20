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
    name             = string
    address_prefixes = list(string)
  }))
}

variable "firewall_subnet_address_prefixes" {
  description = "If not null, a firewall subnet will be created under the virtual network with this address prefixes"
  type        = list(string)
  default     = null
}

variable "gateway_subnet_address_prefixes" {
  description = "If not null, a gateway subnet will be created under the virtual network with this address prefixes"
  type        = list(string)
  default     = null
}
