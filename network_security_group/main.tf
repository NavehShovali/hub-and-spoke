resource "azurerm_network_security_group" "security_group" {
  location            = var.location
  name                = var.name
  resource_group_name = var.resource_group_name

  dynamic "security_rule" {
    for_each = var.security_rules
    content {
      access                     = security_rule.value.access
      direction                  = security_rule.value.direction
      name                       = security_rule.value.name
      priority                   = security_rule.value.priority
      protocol                   = security_rule.value.protocol
      source_port_range          = security_rule.value.source_port_range
      destination_port_range     = security_rule.value.destination_port_range
      source_address_prefix      = security_rule.value.source_address_prefix
      destination_address_prefix = security_rule.value.destination_address_prefix
    }
  }
}