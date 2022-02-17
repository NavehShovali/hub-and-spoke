resource "azurerm_virtual_network_peering" "peering" {
  name                      = "${var.virtual_network_name}-to-${var.remote_virtual_network_name}"
  remote_virtual_network_id = var.remote_virtual_network_id
  resource_group_name       = var.resource_group_name
  virtual_network_name      = var.virtual_network_name
}
