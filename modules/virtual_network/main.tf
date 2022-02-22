resource "azurerm_virtual_network" "virtual_network" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name

  address_space = var.address_space
}

resource "azurerm_subnet" "subnets" {
  for_each = {for subnet in var.subnets : subnet.name => subnet}

  name                = each.key
  resource_group_name = var.resource_group_name

  virtual_network_name                           = azurerm_virtual_network.virtual_network.name
  address_prefixes                               = each.value.address_prefixes
  enforce_private_link_endpoint_network_policies = each.value.enforce_private_link_endpoint_network_policies
}
