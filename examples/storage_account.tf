module "storage_account" {
  source = "../modules/storage_account"

  name                = "${local.environment_prefix}-storage-account"
  location            = local.location
  resource_group_name = azurerm_resource_group.example.name

  depends_on = [azurerm_resource_group.example]
}
