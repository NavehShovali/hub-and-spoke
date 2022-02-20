locals {
  resource_prefix = "naveh-tf-final"
  location        = "westeurope"

  hub_virtual_network = {
    name          = "hub-vnet"
    address_space = ["10.0.0.0/16"]
    subnets       = [
      {
        name             = "default"
        address_prefixes = ["10.0.0.0/25"]
      },
      {
        name             = "GatewaySubnet"
        address_prefixes = ["10.0.1.0/24"]
      },
      {
        name             = "AzureFirewallSubnet"
        address_prefixes = ["10.0.0.128/25"]
      }
    ]
  }

  spoke_virtual_network = {
    name          = "spoke-vnet"
    address_space = ["10.1.0.0/16"]
    subnets       = [
      {
        name             = "default"
        address_prefixes = ["10.1.0.0/24"]
      }
    ]
  }

  virtual_private_network_gateway = {
    name             = "hub-gateway"
    address_prefixes = ["10.2.0.0/24"]
  }

  firewall = {
    name                          = "hub-firewall"
    policy_rule_collection_groups = {
      traffic-rule-collection-group = {
        priority                 = 400
        network_rule_collections = {
          spoke-traffic = {
            action   = "Allow"
            priority = 410
            rules    = {
              from-spoke = {
                protocols             = ["TCP"]
                source_addresses      = ["10.1.0.0/16"]
                destination_addresses = ["10.0.0.0/16"]
                destination_ports     = ["22"]
              }
              to-spoke = {
                protocols             = ["TCP"]
                source_addresses      = ["10.0.0.0/16"]
                destination_addresses = ["10.1.0.0/16"]
                destination_ports     = ["22"]
              }
              vnet-to-hub = {
                protocols             = ["TCP"]
                source_addresses      = ["10.2.0.0/24"]
                destination_addresses = ["10.0.0.0/16"]
                destination_ports     = ["22"]
              }
              vnet-to-spoke = {
                protocols             = ["TCP"]
                source_addresses      = ["10.2.0.0/24"]
                destination_addresses = ["10.1.0.0/16"]
                destination_ports     = ["22"]
              }
            }
          }
        }
      }
    }
  }

  spoke_network_security_group = {
    name           = "spoke-nsg"
    security_rules = {
      allow-ssh = {
        access                     = "Allow"
        direction                  = "Inbound"
        priority                   = 300
        protocol                   = "TCP"
        source_port_range          = "*"
        destination_port_range     = "22"
        source_address_prefix      = "10.2.0.0/24"
        destination_address_prefix = "*"
      }
    }
  }

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

  spoke_route_table = {
    name   = "spoke-route-table"
    routes = [
      {
        name           = "default-to-firewall"
        address_prefix = "0.0.0.0/0"
        next_hop_type  = "VirtualAppliance"
      },
      {
        name           = "hub-to-spoke"
        address_prefix = "10.0.0.0/16"
        next_hop_type  = "VirtualAppliance"
      },
      {
        name           = "vpn-to-spoke"
        address_prefix = "10.2.0.0/24"
        next_hop_type  = "VirtualAppliance"
      }
    ]
  }

  hub_route_table = {
    name   = "hub-route-table"
    routes = [
      {
        name           = "firewall-route"
        address_prefix = "10.1.0.0/16"
        next_hop_type  = "VirtualAppliance"
      },
      {
        name           = "gateway-route"
        address_prefix = "10.0.1.0/24"
        next_hop_type  = "VirtualAppliance"
      }
    ]
  }
}
