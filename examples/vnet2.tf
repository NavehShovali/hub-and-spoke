module "virtual_network2" {
  source = "../modules/virtual_network"

  name                = "${local.environment_prefix}-virtual-network2"
  location            = local.location
  resource_group_name = azurerm_resource_group.example.name

  address_space = ["10.1.0.0/16"]
  subnets       = {
    default = {
      address_prefixes = [
        "10.1.0.0/25"
      ]
    }
  }

  log_analytics_workspace_id = module.log_analytics_workspace.id

  depends_on = [azurerm_resource_group.example, module.log_analytics_workspace]
}
