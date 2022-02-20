variable "location" {
  description = "Location to deploy to"
  type        = string
}

variable "hub_virtual_network" {
  description = "The virtual network to deploy to the hub"
  type        = object({
    name          = string
    address_space = list(string)
    subnets       = list(object({
      name             = string
      address_prefixes = list(string)
    }))
  })
}

variable "spoke_virtual_network" {
  description = "The virtual network to deploy to the spoke"
  type        = object({
    name          = string
    address_space = list(string)
    subnets       = list(object({
      name             = string
      address_prefixes = list(string)
    }))
  })
}

variable "virtual_private_network_gateway" {
  description = "The virtual private network to deploy to the hub"
  type        = object({
    name             = string
    address_prefixes = list(string)
    azure_active_directory_authentication = object({
      audience = string
      issuer   = string
      tenant   = string
    })
  })
}

variable "firewall" {
  description = "The firewall to deploy to the hub"
  type        = object({
    name   = string
    policy_rule_collection_groups = map(object({
      priority                 = number
      network_rule_collections = map(object({
        action   = string
        priority = number
        rules    = map(object({
          protocols             = list(string)
          source_addresses      = list(string)
          destination_addresses = list(string)
          destination_ports     = list(string)
        }))
      }))
    }))
  })
}

variable "spoke_network_security_group" {
  description = "Defines the hub's network security group"
  type        = object({
    name           = string
    security_rules = map(object({
      access                     = string
      direction                  = string
      priority                   = number
      protocol                   = string
      source_port_range          = string
      destination_port_range     = string
      source_address_prefix      = string
      destination_address_prefix = string
    }))
  })
}

variable "virtual_machine_password" {
  description = "Default password value of a virtual machine admin user"
  type        = string
  sensitive   = true
}

variable "spoke_virtual_machine" {
  description = "The virtual machine to deploy to the spoke"
  type        = object({
    name                    = string
    vm_size                 = string
    storage_image_reference = object({
      publisher = string
      offer     = string
      sku       = string
      version   = string
    })
    os_profile = object({
      computer_name  = string
      admin_username = string
    })
  })
}

variable "spoke_storage_account" {
  description = "Defines the storage account to deploy to the spoke"
  type        = object({
    name = string
  })
}

variable "spoke_route_table" {
  description = "Defines the spoke's route table"
  type        = object({
    name   = string
    routes = list(object({
      name           = string
      address_prefix = string
      next_hop_type  = string
    }))
  })
}

variable "hub_route_table" {
  description = "Defines the spoke's route table"
  type        = object({
    name   = string
    routes = list(object({
      name           = string
      address_prefix = string
      next_hop_type  = string
    }))
  })
}
