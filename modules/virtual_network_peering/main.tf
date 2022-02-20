resource "azurerm_virtual_network_peering" "peering" {
  name                         = "${var.virtual_network_name}-to-${var.remote_virtual_network_name}"
  remote_virtual_network_id    = var.remote_virtual_network_id
  resource_group_name          = var.resource_group_name
  virtual_network_name         = var.virtual_network_name
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  allow_gateway_transit        = var.allow_gateway_transit
  use_remote_gateways          = var.use_remote_gateways
}
