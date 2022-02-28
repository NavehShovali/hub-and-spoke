locals {
  policy_rule_collection_groups = {
    traffic-rule-collection-group = {
      priority                 = 400
      network-rule-collections = {
        default = {
          action   = "deny"
          priority = 410
          rules    = {
            external-traffic = {
              protocols             = ["Any"]
              source_addresses      = ["*"]
              destination_addresses = ["*"]
              destination_ports     = ["*"]
            }
          }
        }
      }
    }
  }
}

module "firewall_policy" {
  source = "../modules/firewall_policy"

  name                = "${local.environment_prefix}-firewall-policy"
  location            = local.location
  resource_group_name = azurerm_resource_group.example.name

  policy_rule_collection_groups = local.policy_rule_collection_groups
}
