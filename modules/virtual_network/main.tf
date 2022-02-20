resource "azurerm_virtual_network" "virtual_network" {
  address_space       = var.address_space
  location            = var.location
  name                = var.name
  resource_group_name = var.resource_group_name
}

resource "azurerm_subnet" "subnets" {
  for_each             = {for subnet in var.subnets : subnet.name => subnet}
  name                 = each.key
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.virtual_network.name
  address_prefixes     = each.value.address_prefixes
}

resource "azurerm_subnet" "firewall_subnet" {
  count = var.firewall_subnet_address_prefixes == null ? 0 : 1

  name                 = "AzureFirewallSubnet"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.virtual_network.name
  address_prefixes     = var.firewall_subnet_address_prefixes
}

resource "azurerm_subnet" "gateway_subnet" {
  count = var.firewall_subnet_address_prefixes == null ? 0 : 1

  name                 = "GatewaySubnet"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.virtual_network.name
  address_prefixes     = var.gateway_subnet_address_prefixes
}
