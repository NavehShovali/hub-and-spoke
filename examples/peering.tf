locals {
  virtual_networks_to_peer = {
    virtual-network1 = {
      resource_group_name   = azurerm_resource_group.example.name
      name                  = module.virtual_network1.name
      remote_id             = module.virtual_network2.id
      allow_gateway_transit = true
      use_remote_gateways   = false
    }

    virtual-network2 = {
      resource_group_name   = azurerm_resource_group.example.name
      name                  = module.virtual_network2.name
      remote_id             = module.virtual_network1.id
      allow_gateway_transit = false
      use_remote_gateways   = true
    }
  }
}

module "peering" {
  source = "../modules/bidirectional_virtual_network_peering"

  virtual_networks_to_peer = local.virtual_networks_to_peer

  depends_on = [module.virtual_network1, module.virtual_network2]
}
