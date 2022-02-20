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
  source = "./modules/virtual_network"

  address_space                    = var.hub_virtual_network.address_space
  location                         = var.location
  name                             = "${local.resource_prefix}-${var.hub_virtual_network.name}"
  resource_group_name              = azurerm_resource_group.hub.name
  subnets                          = var.hub_virtual_network.subnets
  firewall_subnet_address_prefixes = var.firewall.subnet.address_prefixes
  gateway_subnet_address_prefixes  = var.virtual_private_network_gateway.subnet.address_prefixes
}

module "spoke_virtual_network" {
  source = "./modules/virtual_network"

  address_space       = var.spoke_virtual_network.address_space
  location            = var.location
  name                = "${local.resource_prefix}-${var.spoke_virtual_network.name}"
  resource_group_name = azurerm_resource_group.spoke.name
  subnets             = var.spoke_virtual_network.subnets
}

locals {
  hub_subnet_id      = module.hub_virtual_network.subnets[0].id
  spoke_subnet_id    = module.spoke_virtual_network.subnets[0].id
  gateway_subnet_id  = module.hub_virtual_network.gateway_subnet_id
  firewall_subnet_id = module.hub_virtual_network.firewall_subnet_id
}

locals {
  virtual_networks_to_peer = {
    var.hub_virtual_network.name = {
      name                  = module.hub_virtual_network.name
      remote_id             = module.spoke_virtual_network.id
      allow_gateway_transit = true
      use_remote_gateways   = false
    }
    var.spoke_virtual_network.name = {
      name                  = module.spoke_virtual_network.name
      remote_id             = module.hub_virtual_network.id
      allow_gateway_transit = false
      use_remote_gateways   = true
    }
  }
}

module "peer_spoke_to_hub" {
  source = "./modules/bidirectional_virtual_network_peering"

  resource_group_name      = azurerm_resource_group.spoke.name
  virtual_networks_to_peer = local.virtual_networks_to_peer
}

module "hub_virtual_private_network_gateway" {
  source = "./modules/virtual_private_network_gateway"

  address_prefixes                      = var.virtual_private_network_gateway.address_prefixes
  azure_active_directory_authentication = var.virtual_private_network_gateway.azure_active_directory_authentication
  location                              = var.location
  name                                  = "${local.resource_prefix}-${var.virtual_private_network_gateway.name}"
  resource_group_name                   = azurerm_resource_group.hub.name
  subnet_id                             = local.gateway_subnet_id
}

module "hub_firewall_policy" {
  source                        = "./modules/firewall_policy"
  location                      = var.location
  name                          = "${local.resource_prefix}-${var.firewall.name}"
  policy_rule_collection_groups = var.firewall.policy_rule_collection_groups
  resource_group_name           = azurerm_resource_group.hub.name
}

module "hub_firewall" {
  source = "./modules/firewall"

  location            = var.location
  name                = "${local.resource_prefix}-${var.firewall.name}"
  resource_group_name = azurerm_resource_group.hub.name
  subnet_id           = local.firewall_subnet_id
  firewall_policy_id  = module.hub_firewall_policy.id
}

module "spoke_network_security_group" {
  source = "./modules/network_security_group"

  location            = var.location
  name                = "${local.resource_prefix}-${var.spoke_network_security_group.name}"
  resource_group_name = azurerm_resource_group.spoke.name
  security_rules      = var.spoke_network_security_group.security_rules
}

resource "azurerm_subnet_network_security_group_association" "spoke" {
  network_security_group_id = module.spoke_network_security_group.id
  subnet_id                 = local.spoke_subnet_id
}

module "spoke_virtual_machine" {
  source = "./modules/virtual_machine"

  location                = var.location
  name                    = "${local.resource_prefix}-${var.spoke_virtual_machine.name}"
  os_profile              = var.spoke_virtual_machine.os_profile
  resource_group_name     = azurerm_resource_group.spoke.name
  storage_image_reference = var.spoke_virtual_machine.storage_image_reference
  subnet_id               = local.spoke_subnet_id
  vm_size                 = var.spoke_virtual_machine.vm_size
  admin_password          = var.virtual_machine_password
}

module "spoke_storage_account" {
  source = "./modules/storage_account"

  location            = var.location
  name                = var.spoke_storage_account.name
  resource_group_name = azurerm_resource_group.spoke.name
}

module "hub_route_table" {
  source = "./modules/route_table"

  associated_subnets_ids = [local.hub_subnet_id, local.gateway_subnet_id]
  firewall_internal_ip   = module.hub_firewall.internal_ip
  location               = var.location
  name                   = "${local.resource_prefix}-${var.hub_route_table.name}"
  resource_group_name    = azurerm_resource_group.hub.name
  routes                 = var.hub_route_table.routes
}

module "spoke_route_table" {
  source = "./modules/route_table"

  associated_subnets_ids = [local.spoke_subnet_id]
  firewall_internal_ip   = module.hub_firewall.internal_ip
  location               = var.location
  name                   = "${local.resource_prefix}-${var.spoke_route_table.name}"
  resource_group_name    = azurerm_resource_group.spoke.name
  routes                 = var.spoke_route_table.routes
}
