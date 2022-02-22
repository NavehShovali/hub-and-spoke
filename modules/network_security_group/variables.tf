variable "resource_group_name" {
  description = "Resource group to deploy to"
  type        = string
}

variable "name" {
  description = "Resource group to use"
  type        = string
}

variable "location" {
  description = "Location to deploy to"
  type        = string
}

variable "security_rules" {
  description = "Network security rules. Note that if a range/prefix parameter is null, its corresponding ranges/prefixes parameter must not be null, and vice versa."
  type        = map(object({
    access                       = string
    direction                    = string
    priority                     = number
    protocol                     = string
    source_port_range            = string
    destination_port_range       = string
    source_address_prefix        = string
    destination_address_prefix   = string
    source_port_ranges           = list(string)
    destination_port_ranges      = list(string)
    source_address_prefixes      = list(string)
    destination_address_prefixes = list(string)
  }))
}

variable "subnet_id" {
  type        = string
  description = "The subnet to associate the NSG with"
}
