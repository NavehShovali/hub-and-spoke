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

module "firewall" {
  source = "../modules/firewall"

  name                = "${local.environment_prefix}-firewall"
  location            = local.location
  resource_group_name = azurerm_resource_group.example.name

  subnet_id                     = module.virtual_network_with_firewall.subnets.AzureFirewallSubnet.id
  policy_rule_collection_groups = local.policy_rule_collection_groups
  private_ip_ranges             = module.virtual_network_with_firewall.subnets.AzureFirewallSubnet.address_prefixes

  log_analytics_workspace_id = module.log_analytics_workspace.id

  depends_on = [module.virtual_network_with_firewall, module.log_analytics_workspace]
}
