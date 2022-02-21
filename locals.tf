locals {
  resource_prefix = "naveh-tf-final"
  location        = "westeurope"

  hub_virtual_network = {
    name          = "hub-vnet"
    address_space = ["10.0.0.0/16"]
    subnets       = [
      {
        name                                           = "default"
        address_prefixes                               = ["10.0.0.0/25"]
        enforce_private_link_endpoint_network_policies = true
      },
      {
        name                                           = "GatewaySubnet"
        address_prefixes                               = ["10.0.1.0/24"]
        enforce_private_link_endpoint_network_policies = true
      },
      {
        name                                           = "AzureFirewallSubnet"
        address_prefixes                               = ["10.0.0.128/25"]
        enforce_private_link_endpoint_network_policies = true
      }
    ]
  }

  spoke_virtual_network = {
    name          = "spoke-vnet"
    address_space = ["10.1.0.0/16"]
    subnets       = [
      {
        name                                           = "default"
        address_prefixes                               = ["10.1.0.0/24"]
        enforce_private_link_endpoint_network_policies = true
      }
    ]
  }

  virtual_private_network_gateway = {
    name             = "hub-gateway"
    address_prefixes = ["10.2.0.0/24"]
  }

  firewall_name = "hub-firewall"

  spoke_network_security_group_name = "spoke-nsg"

  spoke_virtual_machine = {
    name                    = "spoke-vm"
    vm_size                 = "Standard_DS1_v2"
    admin_username          = "naveh"
    operating_system        = "Linux"
    storage_image_reference = {
      publisher = "Canonical"
      offer     = "UbuntuServer"
      sku       = "16.04-LTS"
      version   = "latest"
    }
  }

  spoke_storage_account_name = "spokestorageaccount"

  spoke_route_table_name = "spoke-route-table"

  hub_route_table_name = "hub-route-table"
}
