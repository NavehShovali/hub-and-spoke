resource "azurerm_storage_account" "storage_account" {
  name                     = var.name
  location                 = var.location
  resource_group_name      = var.resource_group_name

  account_replication_type = var.account_replication_type
  account_tier             = var.account_tier

  network_rules {
    default_action = "Deny"
  }
}
