resource "azurerm_public_ip" "public_ip" {
  allocation_method   = "Static"
  location            = var.location
  name                = "${var.name}-public-ip"
  resource_group_name = var.resource_group_name
  sku                 = "Standard"
}

resource "azurerm_firewall" "firewall" {
  location            = var.location
  name                = var.name
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                 = "${var.name}-ip-configuration"
    public_ip_address_id = azurerm_public_ip.public_ip.id
    subnet_id            = var.subnet_id
  }
}

resource "azurerm_firewall_policy" "firewall_policy" {
  location            = var.location
  name                = "${var.name}-policy"
  resource_group_name = var.resource_group_name
}

resource "azurerm_firewall_policy_rule_collection_group" "rule_collection" {
  for_each           = var.policy_rule_collection_groups
  firewall_policy_id = azurerm_firewall_policy.firewall_policy.id
  name               = each.key
  priority           = each.value.priority

  dynamic "network_rule_collection" {
    for_each = each.value.network_rule_collections

    content {
      action   = network_rule_collection.value.action
      name     = network_rule_collection.key
      priority = network_rule_collection.value.priority

      dynamic "rule" {
        for_each = network_rule_collection.value.rules

        content {
          name                  = rule.key
          protocols             = rule.value.protocols
          source_addresses      = rule.value.source_addresses
          destination_addresses = rule.value.destination_addresses
          destination_ports     = rule.value.destination_ports
        }
      }
    }
  }
}
