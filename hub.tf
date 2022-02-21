resource "azurerm_resource_group" "hub" {
  location = local.location
  name     = "${local.resource_prefix}-hub"
}

module "hub_virtual_network" {
  source = "./modules/virtual_network"

  address_space                    = local.hub_virtual_network.address_space
  location                         = local.location
  name                             = "${local.resource_prefix}-${local.hub_virtual_network.name}"
  resource_group_name              = azurerm_resource_group.hub.name
  subnets                          = local.hub_virtual_network.subnets

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
  name                          = "${local.resource_prefix}-${local.firewall.name}"
  policy_rule_collection_groups = jsondecode(file("./rules/firewall_policies/hub_firewall.json"))
  resource_group_name           = azurerm_resource_group.hub.name

  depends_on = [azurerm_resource_group.hub]
}

module "hub_firewall" {
  source = "./modules/firewall"

  location            = local.location
  name                = "${local.resource_prefix}-${local.firewall.name}"
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
  name                   = "${local.resource_prefix}-${local.hub_route_table.name}"
  resource_group_name    = azurerm_resource_group.hub.name
  routes                 = jsondecode(file("./rules/route_tables/hub_route_table.json")).routes

  depends_on = [module.hub_firewall]
}
