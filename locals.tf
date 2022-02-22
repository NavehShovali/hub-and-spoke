locals {
  resource_prefix            = "naveh-tf-final"
  location                   = "westeurope"
  spoke_storage_account_name = "spokestorageaccount"

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

  firewall = {
    name                          = "hub-firewall"
    policy_rule_collection_groups = jsondecode(templatefile("./rules/firewall_policies/hub_firewall.json", {
      spoke_vnet_address_pool      = local.spoke_virtual_network.address_space[0]
      hub_vnet_address_pool        = local.hub_virtual_network.address_space[0]
      hub_gateway_address_prefixes = local.virtual_private_network_gateway.address_prefixes[0]
    }))
  }

  spoke_network_security_group = {
    name           = "spoke-nsg"
    security_rules = jsondecode(templatefile("./rules/network_security_groups/spoke_network_security_group.json", {
      hub_gateway_address_prefix = local.virtual_private_network_gateway.address_prefixes[0]
    }))
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

  spoke_route_table = {
    name   = "spoke-route-table"
    routes = jsondecode(templatefile("./rules/route_tables/spoke_route_table.json", {
      hub_virtual_network_address = local.hub_virtual_network.address_space[0]
      hub_gateway_address_prefix  = local.virtual_private_network_gateway.address_prefixes[0]
    })).routes
  }

  hub_route_table = {
    name   = "hub-route-table"
    routes = jsondecode(templatefile("./rules/route_tables/hub_route_table.json", {
      spoke_virtual_network_address = local.spoke_virtual_network.address_space[0]
      hub_gateway_subnet_address    = local.hub_virtual_network.subnets[1].address_prefixes[0]
    })).routes
  }
}
