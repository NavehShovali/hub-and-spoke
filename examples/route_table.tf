module "route_table" {
  source = "../modules/route_table"

  name                = "example-route-table"
  location            = "westeurope"
  resource_group_name = azurerm_resource_group.example.name

  associated_subnets_ids = [module.virtual_network_with_firewall.subnets.default.id]
  routes                 = {
    default-to-firewall : {
      address_prefix         = "0.0.0.0/0"
      next_hop_type          = "VirtualAppliance"
      next_hop_in_ip_address = module.firewall.private_ip
    }
  }

  depends_on = [module.firewall]
}