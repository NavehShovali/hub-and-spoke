module "hub_virtual_network" {
  source = "./modules/virtual_network"

  name                = "${local.environment_prefix}-${local.hub_virtual_network.name}"
  location            = local.location
  resource_group_name = azurerm_resource_group.hub.name

  address_space = local.hub_virtual_network.address_space
  subnets       = local.hub_virtual_network.subnets

  log_analytics_workspace_id = module.log_analytics_workspace.id

  depends_on = [azurerm_resource_group.hub, module.log_analytics_workspace]
}

locals {
  hub_subnet_id      = module.hub_virtual_network.subnets["default"].id
  gateway_subnet_id  = module.hub_virtual_network.subnets["GatewaySubnet"].id
  firewall_subnet_id = module.hub_virtual_network.subnets["AzureFirewallSubnet"].id
}

module "hub_virtual_private_network_gateway" {
  source = "./modules/virtual_private_network_gateway"

  name                = "${local.environment_prefix}-${local.virtual_private_network_gateway.name}"
  location            = local.location
  resource_group_name = azurerm_resource_group.hub.name

  address_prefixes                      = local.virtual_private_network_gateway.address_prefixes
  azure_active_directory_authentication = var.azure_active_directory_authentication
  subnet_id                             = local.gateway_subnet_id

  depends_on = [module.hub_virtual_network]
}

module "hub_firewall" {
  source = "./modules/firewall"

  name                = "${local.environment_prefix}-${local.firewall.name}"
  location            = local.location
  resource_group_name = azurerm_resource_group.hub.name

  subnet_id                     = local.firewall_subnet_id
  policy_rule_collection_groups = local.firewall.policy_rule_collection_groups
  private_ip_ranges             = local.firewall.private_ip_ranges

  log_analytics_workspace_id = module.log_analytics_workspace.id

  depends_on = [module.hub_virtual_network, module.log_analytics_workspace]
}

locals {
  hub_route_table = {
    name   = "hub-route-table"
    routes = jsondecode(templatefile("./rules/route_tables/hub_route_table.json", {
      spoke_virtual_network_address = local.spoke_virtual_network.address_space[0]
      hub_gateway_subnet_address    = local.hub_virtual_network.subnets.GatewaySubnet.address_prefixes[0]
      firewall_private_ip           = module.hub_firewall.private_ip
    }))
  }
}

module "hub_route_table" {
  source = "./modules/route_table"

  name                = "${local.environment_prefix}-${local.hub_route_table.name}"
  location            = local.location
  resource_group_name = azurerm_resource_group.hub.name

  associated_subnets_ids = [local.hub_subnet_id, local.gateway_subnet_id]
  routes                 = local.hub_route_table.routes

  depends_on = [module.hub_firewall]
}
