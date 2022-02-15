variable "resource_group_name" {
  description = "Resource group to deploy to"
  type        = string
}

variable "name" {
  type        = string
  description = "Resource group to use"
}

variable "location" {
  type        = string
  description = "Location to deploy to"
}

variable "security_rules" {
  type = list(object({
    access                     = string
    direction                  = string
    name                       = string
    priority                   = number
    protocol                   = string
    source_port_range          = string
    destination_port_range     = string
    source_address_prefix      = string
    destination_address_prefix = string
  }))
  description = "Network security rules"
}
