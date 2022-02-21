resource "azurerm_resource_group" "spoke" {
  location = local.location
  name     = "${local.resource_prefix}-spoke"
}

module "spoke_virtual_network" {
  source = "./modules/virtual_network"

  address_space       = local.spoke_virtual_network.address_space
  location            = local.location
  name                = "${local.resource_prefix}-${local.spoke_virtual_network.name}"
  resource_group_name = azurerm_resource_group.spoke.name
  subnets             = local.spoke_virtual_network.subnets

  depends_on = [azurerm_resource_group.spoke]
}

locals {
  spoke_subnet_id = module.spoke_virtual_network.subnets["default"].id
}

module "spoke_network_security_group" {
  source = "./modules/network_security_group"

  location            = local.location
  name                = "${local.resource_prefix}-${local.spoke_network_security_group_name}"
  resource_group_name = azurerm_resource_group.spoke.name
  security_rules      = jsondecode(file("./rules/network_security_groups/spoke_network_security_group.json"))

  depends_on = [module.spoke_virtual_network]
}

resource "azurerm_subnet_network_security_group_association" "spoke" {
  network_security_group_id = module.spoke_network_security_group.id
  subnet_id                 = local.spoke_subnet_id

  depends_on = [module.spoke_virtual_network]
}

module "spoke_virtual_machine" {
  source = "./modules/virtual_machine"

  admin_password          = var.virtual_machine_admin_password
  admin_username          = local.spoke_virtual_machine.admin_username
  location                = local.location
  name                    = local.spoke_virtual_machine.name
  operating_system        = local.spoke_virtual_machine.operating_system
  resource_group_name     = azurerm_resource_group.spoke.name
  storage_image_reference = local.spoke_virtual_machine.storage_image_reference
  subnet_id               = local.spoke_subnet_id
  vm_size                 = local.spoke_virtual_machine.vm_size

  depends_on = [module.spoke_virtual_network]
}

module "spoke_storage_account" {
  source = "./modules/storage_account"

  location            = local.location
  name                = local.spoke_storage_account_name
  resource_group_name = azurerm_resource_group.spoke.name

  depends_on = [azurerm_resource_group.spoke]
}

module "spoke_route_table" {
  source = "./modules/route_table"

  associated_subnets_ids = [local.spoke_subnet_id]
  firewall_internal_ip   = module.hub_firewall.internal_ip
  location               = local.location
  name                   = "${local.resource_prefix}-${local.spoke_route_table_name}"
  resource_group_name    = azurerm_resource_group.spoke.name
  routes                 = jsondecode(file("./rules/route_tables/spoke_route_table.json")).routes

  depends_on = [module.hub_firewall]
}
