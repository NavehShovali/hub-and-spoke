locals {
  spoke_storage_account_name = "spokestorageaccount"

  spoke_virtual_network = {
    name                       = "spoke-vnet"
    address_space              = ["10.1.0.0/16"]
    subnets                    = {
      default = {
        address_prefixes = ["10.1.0.0/24"]
      }
    }
  }

  spoke_network_security_group = {
    name           = "spoke-nsg"
    security_rules = jsondecode(templatefile("./rules/network_security_groups/spoke_network_security_group.json", {
      hub_gateway_address_prefix  = local.virtual_private_network_gateway.address_prefixes[0]
      spoke_subnet_address_prefix = local.spoke_virtual_network.subnets.default.address_prefixes[0]
    }))
  }

  spoke_virtual_machine = {
    name                    = "spoke-vm"
    vm_size                 = "Standard_DS1_v2"
    admin_username          = "naveh"
    is_linux                = true
    storage_image_reference = {
      publisher = "Canonical"
      offer     = "UbuntuServer"
      sku       = "16.04-LTS"
      version   = "latest"
    }
  }
}

resource "azurerm_resource_group" "spoke" {
  location = local.location
  name     = "${local.environment_prefix}-spoke"
}
