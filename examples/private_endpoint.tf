module "storage_account_private_endpoint" {
  source = "../modules/private_endpoint"

  name                = "example-private-endpoint"
  location            = "westeurope"
  resource_group_name = azurerm_resource_group.example.name

  private_connection_resource_id = module.storage_account.id
  subnet_id                      = module.virtual_network1.subnets.default.id

  depends_on = [module.virtual_network1, module.storage_account]
}
