locals {
  environment_prefix = "naveh-tf-final"
  location           = "westeurope"

  virtual_networks_to_peer = {
    (local.hub_virtual_network.name) = {
      resource_group_name   = azurerm_resource_group.hub.name
      name                  = module.hub_virtual_network.name
      remote_id             = module.spoke_virtual_network.id
      allow_gateway_transit = true
      use_remote_gateways   = false
    }
    (local.spoke_virtual_network.name) = {
      resource_group_name   = azurerm_resource_group.spoke.name
      name                  = module.spoke_virtual_network.name
      remote_id             = module.hub_virtual_network.id
      allow_gateway_transit = false
      use_remote_gateways   = true
    }
  }
}

module "peer_hub_and_spoke" {
  source = "./modules/bidirectional_virtual_network_peering"

  virtual_networks_to_peer = local.virtual_networks_to_peer

  depends_on = [
    module.hub_virtual_network, module.spoke_virtual_network, module.hub_virtual_private_network_gateway
  ]
}

resource "azurerm_resource_group" "common" {
  location = local.location
  name     = "${local.environment_prefix}-common"
}

module "log_analytics_workspace" {
  source = "./modules/logs_analytics_workspace"

  location            = local.location
  name                = "${local.environment_prefix}-log-analytics-workspace"
  resource_group_name = azurerm_resource_group.common.name
}
