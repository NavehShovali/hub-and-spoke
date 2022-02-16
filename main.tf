locals {
  resource_prefix = "naveh-tf-final"
}

resource "azurerm_resource_group" "hub" {
  location = var.location
  name     = "${local.resource_prefix}-hub"
}

resource "azurerm_resource_group" "spoke" {
  location = var.location
  name     = "${local.resource_prefix}-spoke"
}

module "hub_virtual_network" {
  source = "./virtual_network"

  address_space       = var.hub_virtual_network.address_space
  location            = var.location
  name                = "${local.resource_prefix}-${var.hub_virtual_network.name}"
  resource_group_name = azurerm_resource_group.hub.name
  subnets             = concat([
    var.virtual_private_network_gateway.subnet, var.firewall.subnet
  ], var.hub_virtual_network.subnets)
}

locals {
  gateway_subnet_id  = module.hub_virtual_network.subnets[0].id
  firewall_subnet_id = module.hub_virtual_network.subnets[1].id
  hub_subnet_id      = module.hub_virtual_network.subnets[2].id
}

module "hub_virtual_private_network_gateway" {
  source = "./virtual_private_network_gateway"

  address_prefixes                      = var.virtual_private_network_gateway.address_prefixes
  azure_active_directory_authentication = var.virtual_private_network_gateway.azure_active_directory_authentication
  location                              = var.location
  name                                  = "${local.resource_prefix}-${var.virtual_private_network_gateway.name}"
  resource_group_name                   = azurerm_resource_group.hub.name
  subnet_id                             = local.gateway_subnet_id
}

module "hub_firewall" {
  source = "./firewall"

  location                      = var.location
  name                          = "${local.resource_prefix}-${var.firewall.name}"
  policy_rule_collection_groups = var.firewall.policy_rule_collection_groups
  resource_group_name           = azurerm_resource_group.hub.name
  subnet_id                     = local.firewall_subnet_id
}

module "spoke_virtual_network" {
  source = "./virtual_network"

  address_space       = var.spoke_virtual_network.address_space
  location            = var.location
  name                = "${local.resource_prefix}-${var.spoke_virtual_network.name}"
  resource_group_name = azurerm_resource_group.spoke.name
  subnets             = var.spoke_virtual_network.subnets
}

locals {
  spoke_subnet_id = module.spoke_virtual_network.subnets[0].id
}

module "spoke_network_security_group" {
  source = "./network_security_group"

  location            = var.location
  name                = "${local.resource_prefix}-${var.spoke_network_security_group}"
  resource_group_name = azurerm_resource_group.spoke.name
  security_rules      = var.spoke_network_security_group.security_rules
}

resource "azurerm_subnet_network_security_group_association" "spoke" {
  network_security_group_id = module.spoke_network_security_group
  subnet_id                 = local.spoke_subnet_id.id
}

module "spoke_virtual_machine" {
  source = "./virtual_machine"

  location                = var.location
  name                    = "${local.resource_prefix}-${var.spoke_virtual_machine.name}"
  os_profile              = var.spoke_virtual_machine.os_profile
  resource_group_name     = azurerm_resource_group.spoke.name
  storage_image_reference = var.spoke_virtual_machine.storage_image_reference
  subnet_id               = local.spoke_subnet_id
  vm_size                 = var.spoke_virtual_machine.vm_size
}

module "spoke_storage_account" {
  source = "./storage_account"

  location            = var.location
  name                = var.spoke_storage_account.name
  resource_group_name = azurerm_resource_group.spoke.name
}

locals {
  route_tables_associations = {
    spoke-route-table = [local.spoke_subnet_id]
    hub-route-table   = [local.hub_subnet_id, local.gateway_subnet_id]
  }

  route_tables_resource_groups = {
    spoke-route-table = azurerm_resource_group.spoke.name
    hub-route-table   = azurerm_resource_group.hub.name
  }
}

module "route_tables" {
  source   = "./route_table"
  for_each = var.route_tables

  associated_subnets_ids = local.route_tables_associations[each.key]
  firewall_internal_ip   = module.hub_firewall.internal_ip
  location               = var.location
  name                   = each.key
  resource_group_name    = local.route_tables_resource_groups[each.key]
  routes                 = each.value["routes"]
}
