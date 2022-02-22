resource "azurerm_private_endpoint" "storage_account_private_endpoint" {
  location            = var.location
  name                = var.name
  resource_group_name = var.resource_group_name
  subnet_id           = var.subnet_id

  private_service_connection {
    is_manual_connection           = false
    name                           = "${var.name}-private-service-connection"
    private_connection_resource_id = var.private_connection_resource_id
    subresource_names              = var.connection_subresources_names
  }
}
