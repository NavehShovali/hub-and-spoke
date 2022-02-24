resource "azurerm_network_security_group" "security_group" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name

  dynamic "security_rule" {
    for_each = var.security_rules
    content {
      access                       = security_rule.value.access
      direction                    = security_rule.value.direction
      name                         = security_rule.key
      priority                     = security_rule.value.priority
      protocol                     = security_rule.value.protocol
      source_port_range            = security_rule.value.source_port_range
      destination_port_range       = security_rule.value.destination_port_range
      source_address_prefix        = security_rule.value.source_address_prefix
      destination_address_prefix   = security_rule.value.destination_address_prefix
      source_port_ranges           = security_rule.value.source_port_ranges
      destination_port_ranges      = security_rule.value.destination_port_ranges
      source_address_prefixes      = security_rule.value.source_address_prefixes
      destination_address_prefixes = security_rule.value.destination_address_prefixes
    }
  }
}

resource "azurerm_subnet_network_security_group_association" "security_group_association" {
  network_security_group_id = azurerm_network_security_group.security_group.id
  subnet_id                 = var.subnet_id

  depends_on = [azurerm_network_security_group.security_group]
}
