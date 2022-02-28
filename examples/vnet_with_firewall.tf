module "virtual_network_with_firewall" {
  source = "../modules/virtual_network"

  name                = "${local.environment_prefix}-virtual-network-with-firewall"
  location            = local.location
  resource_group_name = azurerm_resource_group.example.name

  address_space = ["10.3.0.0/16"]
  subnets       = {
    default = {
      address_prefixes = [
        "10.3.0.0/25"
      ]
    }
    AzureFirewallSubnet = {
      address_prefixes = [
        "10.3.0.128/25"
      ]
    }
  }

  log_analytics_workspace_id = module.log_analytics_workspace.id

  depends_on = [azurerm_resource_group.example, module.log_analytics_workspace]
}
