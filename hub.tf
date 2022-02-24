locals {
  hub_virtual_network = {
    name                       = "hub-vnet"
    address_space              = ["10.0.0.0/16"]
    diagnostic_logs_categories = ["VMProtectionAlerts"]
    subnets                    = [
      {
        name                                           = "default"
        address_prefixes                               = ["10.0.0.0/25"]
        enforce_private_link_endpoint_network_policies = true
      },
      {
        name                                           = "GatewaySubnet"
        address_prefixes                               = ["10.0.1.0/24"]
        enforce_private_link_endpoint_network_policies = true
      },
      {
        name                                           = "AzureFirewallSubnet"
        address_prefixes                               = ["10.0.0.128/25"]
        enforce_private_link_endpoint_network_policies = true
      }
    ]
  }

  virtual_private_network_gateway = {
    name             = "hub-gateway"
    address_prefixes = ["10.2.0.0/24"]
  }

  firewall = {
    name                       = "hub-firewall"
    private_ip_ranges          = module.hub_virtual_network.subnets["AzureFirewallSubnet"].address_prefixes
    diagnostic_logs_categories = [
      "AzureFirewallApplicationRule", "AzureFirewallNetworkRule", "AzureFirewallDnsProxy"
    ]
    policy_rule_collection_groups = jsondecode(templatefile("./rules/firewall_policies/hub_firewall.json", {
      spoke_vnet_address_pool      = local.spoke_virtual_network.address_space[0]
      hub_vnet_address_pool        = local.hub_virtual_network.address_space[0]
      hub_gateway_address_prefixes = local.virtual_private_network_gateway.address_prefixes[0]
    }))
  }
}

resource "azurerm_resource_group" "hub" {
  location = local.location
  name     = "${local.environment_prefix}-hub"
}

module "hub_virtual_network" {
  source = "./modules/virtual_network"

  name                = "${local.environment_prefix}-${local.hub_virtual_network.name}"
  location            = local.location
  resource_group_name = azurerm_resource_group.hub.name

  address_space = local.hub_virtual_network.address_space
  subnets       = local.hub_virtual_network.subnets

  depends_on = [azurerm_resource_group.hub]
}

locals {
  hub_subnet_id      = module.hub_virtual_network.subnets["default"].id
  gateway_subnet_id  = module.hub_virtual_network.subnets["GatewaySubnet"].id
  firewall_subnet_id = module.hub_virtual_network.subnets["AzureFirewallSubnet"].id
}

module "hub_virtual_private_network_gateway" {
  source = "./modules/virtual_private_network_gateway"

  name                = "${local.environment_prefix}-${local.virtual_private_network_gateway.name}"
  location            = local.location
  resource_group_name = azurerm_resource_group.hub.name

  address_prefixes                      = local.virtual_private_network_gateway.address_prefixes
  azure_active_directory_authentication = var.azure_active_directory_authentication
  subnet_id                             = local.gateway_subnet_id

  depends_on = [module.hub_virtual_network]
}

module "hub_firewall" {
  source = "./modules/firewall"

  name                = "${local.environment_prefix}-${local.firewall.name}"
  location            = local.location
  resource_group_name = azurerm_resource_group.hub.name

  subnet_id                     = local.firewall_subnet_id
  policy_rule_collection_groups = local.firewall.policy_rule_collection_groups
  private_ip_ranges             = local.firewall.private_ip_ranges

  depends_on = [module.hub_virtual_network]
}

locals {
  hub_route_table = {
    name   = "hub-route-table"
    routes = jsondecode(templatefile("./rules/route_tables/hub_route_table.json", {
      spoke_virtual_network_address = local.spoke_virtual_network.address_space[0]
      hub_gateway_subnet_address    = local.hub_virtual_network.subnets[1].address_prefixes[0]
      firewall_private_ip           = module.hub_firewall.private_ip
    }))
  }
}

module "hub_route_table" {
  source = "./modules/route_table"

  name                = "${local.environment_prefix}-${local.hub_route_table.name}"
  location            = local.location
  resource_group_name = azurerm_resource_group.hub.name

  associated_subnets_ids = [local.hub_subnet_id, local.gateway_subnet_id]
  routes                 = local.hub_route_table.routes

  depends_on = [module.hub_firewall]
}

module "hub_vnet_diagnostic_settings" {
  source = "./modules/diagnostic_settings"

  log_categories       = local.hub_virtual_network.diagnostic_logs_categories
  storage_account_id   = module.spoke_storage_account.id
  target_resource_name = module.hub_virtual_network
  target_resource_id   = module.hub_virtual_network.id

  depends_on = [module.spoke_storage_account, module.hub_virtual_network]
}

module "firewall_diagnostic_settings" {
  source = "./modules/diagnostic_settings"

  log_categories       = local.firewall.diagnostic_logs_categories
  storage_account_id   = module.spoke_storage_account.id
  target_resource_name = module.hub_firewall.name
  target_resource_id   = module.hub_firewall.id

  depends_on = [module.spoke_storage_account, module.hub_firewall]
}
