resource "azurerm_firewall_policy" "firewall_policy" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
}

resource "azurerm_firewall_policy_rule_collection_group" "rule_collections" {
  for_each = var.policy_rule_collection_groups

  name               = each.key
  priority           = each.value.priority
  firewall_policy_id = azurerm_firewall_policy.firewall_policy.id

  dynamic "network_rule_collection" {
    for_each = coalesce(each.value.network_rule_collections, {})

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

  dynamic "nat_rule_collection" {
    for_each = coalesce(each.value.nat_rule_collections, {})

    content {
      action   = nat_rule_collection.value.action
      name     = nat_rule_collection.key
      priority = nat_rule_collection.value.priority

      dynamic "rule" {
        for_each = nat_rule_collection.value.rules

        content {
          name                = rule.key
          protocols           = rule.value.protocols
          source_addresses    = rule.value.source_addresses
          destination_address = rule.value.destination_address
          destination_ports   = rule.value.destination_ports
          translated_address  = rule.value.translated_address
          translated_port     = rule.value.translated_port
        }
      }
    }
  }

  dynamic "application_rule_collection" {
    for_each = coalesce(each.value.application_rule_collection, {})

    content {
      action   = application_rule_collection.value.action
      name     = application_rule_collection.key
      priority = application_rule_collection.value.priority

      dynamic "rule" {
        for_each = application_rule_collection.value.rules

        content {
          name                  = rule.key
          source_addresses      = rule.value.source_addresses
          source_ip_groups      = rule.value.source_ip_groups
          destination_addresses = rule.value.destination_addresses
          destination_urls      = rule.value.destination_urls
          destination_fqdns     = rule.value.destination_fqdns
          destination_fqdn_tags = rule.value.destination_fqdn_tags
          terminate_tls         = rule.value.terminate_tls
          web_categories        = rule.value.web_categories

          dynamic "protocols" {
            for_each = rule.value.protocols
            content {
              type = protocols.key
              port = protocols.value
            }
          }
        }
      }
    }
  }
}
