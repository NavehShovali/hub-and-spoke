resource "azurerm_resource_group" "hub" {
  location = local.location
  name     = "${local.resource_prefix}-hub"
}

module "hub_virtual_network" {
  source = "./modules/virtual_network"

  address_space       = local.hub_virtual_network.address_space
  location            = local.location
  name                = "${local.resource_prefix}-${local.hub_virtual_network.name}"
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
  name                                  = "${local.resource_prefix}-${local.virtual_private_network_gateway.name}"
  resource_group_name                   = azurerm_resource_group.hub.name
  subnet_id                             = local.gateway_subnet_id

  depends_on = [module.hub_virtual_network]
}

module "hub_firewall_policy" {
  source                        = "./modules/firewall_policy"
  location                      = local.location
  name                          = "${local.resource_prefix}-${local.firewall_name}"
  resource_group_name           = azurerm_resource_group.hub.name
  policy_rule_collection_groups = jsondecode(templatefile("./rules/firewall_policies/hub_firewall.json", {
    spoke_vnet_address_pool      = local.spoke_virtual_network.address_space[0]
    hub_vnet_address_pool        = local.hub_virtual_network.address_space[0]
    hub_gateway_address_prefixes = local.virtual_private_network_gateway.address_prefixes[0]
  }))

  depends_on = [azurerm_resource_group.hub]
}

module "hub_firewall" {
  source = "./modules/firewall"

  location            = local.location
  name                = "${local.resource_prefix}-${local.firewall_name}"
  resource_group_name = azurerm_resource_group.hub.name
  subnet_id           = local.firewall_subnet_id
  firewall_policy_id  = module.hub_firewall_policy.id

  depends_on = [module.hub_firewall_policy]
}

module "hub_route_table" {
  source = "./modules/route_table"

  associated_subnets_ids = [local.hub_subnet_id, local.gateway_subnet_id]
  firewall_internal_ip   = module.hub_firewall.internal_ip
  location               = local.location
  name                   = "${local.resource_prefix}-${local.hub_route_table_name}"
  resource_group_name    = azurerm_resource_group.hub.name
  routes                 = jsondecode(templatefile("./rules/route_tables/hub_route_table.json", {
    spoke_virtual_network_address = local.spoke_virtual_network.address_space[0]
    hub_gateway_subnet_address = local.hub_virtual_network.subnets[1].address_prefixes[0]
  })).routes

  depends_on = [module.hub_firewall]
}
