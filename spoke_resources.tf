module "spoke_virtual_network" {
  source = "./modules/virtual_network"

  name                = "${local.environment_prefix}-${local.spoke_virtual_network.name}"
  location            = local.location
  resource_group_name = azurerm_resource_group.spoke.name

  address_space = local.spoke_virtual_network.address_space
  subnets       = local.spoke_virtual_network.subnets

  log_analytics_workspace_id = module.log_analytics_workspace.id

  depends_on = [azurerm_resource_group.spoke, module.log_analytics_workspace]
}

locals {
  spoke_subnet_id = module.spoke_virtual_network.subnets["default"].id
}

module "spoke_network_security_group" {
  source = "./modules/network_security_group"

  name                = "${local.environment_prefix}-${local.spoke_network_security_group.name}"
  location            = local.location
  resource_group_name = azurerm_resource_group.spoke.name

  security_rules = local.spoke_network_security_group.security_rules
  subnet_id      = local.spoke_subnet_id

  depends_on = [module.spoke_virtual_network]
}

module "spoke_storage_account" {
  source = "./modules/storage_account"

  name                = local.spoke_storage_account_name
  location            = local.location
  resource_group_name = azurerm_resource_group.spoke.name

  depends_on = [azurerm_resource_group.spoke]
}

module "spoke_virtual_machine" {
  source = "./modules/virtual_machine"

  name                = local.spoke_virtual_machine.name
  location            = local.location
  resource_group_name = azurerm_resource_group.spoke.name

  storage_image_reference = local.spoke_virtual_machine.storage_image_reference
  is_linux                = true
  vm_size                 = local.spoke_virtual_machine.vm_size
  subnet_id               = local.spoke_subnet_id

  admin_password = var.virtual_machine_admin_password
  admin_username = local.spoke_virtual_machine.admin_username

  log_analytics_workspace_id = module.log_analytics_workspace.id

  depends_on = [module.spoke_virtual_network, module.log_analytics_workspace]
}

module "spoke_storage_account_private_endpoint" {
  source = "./modules/private_endpoint"

  name                = "${local.spoke_storage_account_name}-private-endpoint"
  location            = local.location
  resource_group_name = azurerm_resource_group.spoke.name

  private_connection_resource_id = module.spoke_storage_account.id
  subnet_id                      = local.spoke_subnet_id

  depends_on = [module.spoke_storage_account]
}

locals {
  spoke_route_table = {
    name   = "spoke-route-table"
    routes = jsondecode(templatefile("./rules/route_tables/spoke_route_table.json", {
      hub_virtual_network_address = local.hub_virtual_network.address_space[0]
      hub_gateway_address_prefix  = local.virtual_private_network_gateway.address_prefixes[0]
      firewall_private_ip         = module.hub_firewall.private_ip
    }))
  }
}

module "spoke_route_table" {
  source = "./modules/route_table"

  name                = "${local.environment_prefix}-${local.spoke_route_table.name}"
  location            = local.location
  resource_group_name = azurerm_resource_group.spoke.name

  associated_subnets_ids = [local.spoke_subnet_id]
  routes                 = local.spoke_route_table.routes

  depends_on = [module.hub_firewall]
}
