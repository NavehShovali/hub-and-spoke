resource "azurerm_storage_account" "storage_account" {
  account_replication_type = var.account_replication_type
  account_tier             = var.account_tier
  location                 = var.location
  name                     = var.name
  resource_group_name      = var.resource_group_name

  network_rules {
    default_action = "Deny"
  }
}

resource "azurerm_private_endpoint" "storage_account_private_endpoint" {
  location            = var.location
  name                = "${var.name}-private-endpoint"
  resource_group_name = var.resource_group_name
  subnet_id           = var.subnet_id

  private_service_connection {
    is_manual_connection           = false
    name                           = "${var.name}-private-service-connection"
    private_connection_resource_id = azurerm_storage_account.storage_account.id
    subresource_names              = var.connection_subresources_names
  }
}
