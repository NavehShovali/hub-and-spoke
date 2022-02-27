resource "azurerm_virtual_network" "virtual_network" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name

  address_space = var.address_space
}

resource "azurerm_subnet" "subnets" {
  for_each = var.subnets

  name                = each.key
  resource_group_name = var.resource_group_name

  virtual_network_name                           = azurerm_virtual_network.virtual_network.name
  address_prefixes                               = each.value.address_prefixes
  enforce_private_link_endpoint_network_policies = coalesce(each.value.enforce_private_link_endpoint_network_policies, true)

  depends_on = [azurerm_virtual_network.virtual_network]
}

module "vnet_diagnostic_settings" {
  source = "../diagnostic_settings"

  log_analytics_workspace_id = var.log_analytics_workspace_id
  target_resource_name       = azurerm_virtual_network.virtual_network.name
  target_resource_id         = azurerm_virtual_network.virtual_network.id

  depends_on = [azurerm_virtual_network.virtual_network]
}

