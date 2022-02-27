locals {
  hub_virtual_network = {
    name                       = "hub-vnet"
    address_space              = ["10.0.0.0/16"]
    subnets                    = {
      default = {
        address_prefixes = [
          "10.0.0.0/25"
        ]
      }
      GatewaySubnet = {
        address_prefixes = ["10.0.1.0/24"]
      }
      AzureFirewallSubnet = {
        address_prefixes = ["10.0.0.128/25"]
      }
    }
  }

  virtual_private_network_gateway = {
    name             = "hub-gateway"
    address_prefixes = ["10.2.0.0/24"]
  }

  firewall = {
    name                       = "hub-firewall"
    private_ip_ranges          = module.hub_virtual_network.subnets["AzureFirewallSubnet"].address_prefixes
    policy_rule_collection_groups = jsondecode(templatefile("./rules/firewall_policies/hub_firewall.json", {
      spoke_vnet_address_pool      = local.spoke_virtual_network.address_space[0]
      hub_vnet_address_pool        = local.hub_virtual_network.address_space[0]
      hub_gateway_address_prefixes = local.virtual_private_network_gateway.address_prefixes[0]
    }))
  }
}

resource "azurerm_resource_group" "hub" {
  location = local.location
  name     = "${local.environment_prefix}-hub"
}
