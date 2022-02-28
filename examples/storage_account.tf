module "storage_account" {
  source = "../modules/storage_account"

  name                = "example-storage-account"
  location            = "westeurope"
  resource_group_name = azurerm_resource_group.example.name

  depends_on = [azurerm_resource_group.example]
}
