locals {
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

  hub_route_table = {
    name   = "hub-route-table"
    routes = jsondecode(templatefile("./rules/route_tables/hub_route_table.json", {
      spoke_virtual_network_address = local.spoke_virtual_network.address_space[0]
      hub_gateway_subnet_address    = local.hub_virtual_network.subnets[1].address_prefixes[0]
    })).routes
  }
}

resource "azurerm_resource_group" "hub" {
  location = local.location
  name     = "${local.environment_prefix}-hub"
}

module "hub_virtual_network" {
  source = "./modules/virtual_network"

  address_space       = local.hub_virtual_network.address_space
  location            = local.location
  name                = "${local.environment_prefix}-${local.hub_virtual_network.name}"
  resource_group_name = azurerm_resource_group.hub.name
  subnets             = local.hub_virtual_network.subnets

  depends_on = [azurerm_resource_group.hub]
}

locals {
  hub_subnet_id      = module.hub_virtual_network.subnets["default"].id
  gateway_subnet_id  = module.hub_virtual_network.subnets["GatewaySubnet"].id
  firewall_subnet_id = module.hub_virtual_network.subnets["AzureFirewallSubnet"].id
}

module "hub_virtual_private_network_gateway" {
  source = "./modules/virtual_private_network_gateway"

  address_prefixes                      = local.virtual_private_network_gateway.address_prefixes
  azure_active_directory_authentication = var.azure_active_directory_authentication
  location                              = local.location
  name                                  = "${local.environment_prefix}-${local.virtual_private_network_gateway.name}"
  resource_group_name                   = azurerm_resource_group.hub.name
  subnet_id                             = local.gateway_subnet_id

  depends_on = [module.hub_virtual_network]
}

module "hub_firewall" {
  source = "./modules/firewall"

  location                      = local.location
  name                          = "${local.environment_prefix}-${local.firewall.name}"
  resource_group_name           = azurerm_resource_group.hub.name
  subnet_id                     = local.firewall_subnet_id
  policy_rule_collection_groups = local.firewall.policy_rule_collection_groups

  depends_on = [module.hub_virtual_network]
}

module "hub_route_table" {
  source = "./modules/route_table"

  associated_subnets_ids = [local.hub_subnet_id, local.gateway_subnet_id]
  firewall_private_ip    = module.hub_firewall.private_ip
  location               = local.location
  name                   = "${local.environment_prefix}-${local.hub_route_table.name}"
  resource_group_name    = azurerm_resource_group.hub.name
  routes                 = local.hub_route_table.routes

  depends_on = [module.hub_firewall]
}
