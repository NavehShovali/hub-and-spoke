resource "azurerm_virtual_network_peering" "peerings" {
  for_each = var.virtual_networks_to_peer

  name                         = "peer-${each.key}"
  remote_virtual_network_id    = each.value.remote_id
  resource_group_name          = each.value.resource_group_name
  virtual_network_name         = each.value.name
  allow_virtual_network_access = coalesce(each.value.allow_virtual_network_access, true)
  allow_forwarded_traffic      = coalesce(each.value.allow_forwarded_traffic, true)
  allow_gateway_transit        = each.value.allow_gateway_transit
  use_remote_gateways          = each.value.use_remote_gateways
}
