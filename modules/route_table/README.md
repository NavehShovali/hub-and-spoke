<!-- BEGIN_TF_DOCS -->
# Route table

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.1.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | ~> 2.97 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | ~> 2.97 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_route_table.route_table](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/route_table) | resource |
| [azurerm_subnet_route_table_association.route_table](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet_route_table_association) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_associated_subnets_ids"></a> [associated\_subnets\_ids](#input\_associated\_subnets\_ids) | List of the IDs of the subnets associated with the route table | `list(string)` | n/a | yes |
| <a name="input_location"></a> [location](#input\_location) | Location to deploy to | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | The route table's name | `string` | n/a | yes |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | Resource group to deploy to | `string` | n/a | yes |
| <a name="input_routes"></a> [routes](#input\_routes) | The route table's route definitions | <pre>map(object({<br>    address_prefix         = string<br>    next_hop_type          = string<br>    next_hop_in_ip_address = optional(string)<br>  }))</pre> | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_id"></a> [id](#output\_id) | The ID of the route table |
| <a name="output_name"></a> [name](#output\_name) | The name of the route table |
| <a name="output_object"></a> [object](#output\_object) | The data object of the route table |

## Example

```hcl
locals {
  environment_prefix = "example"
  location           = "westeurope"
}

resource "azurerm_resource_group" "example" {
  location = local.location
  name     = "${local.environment_prefix}-rg"
}

module "log_analytics_workspace" {
  source = "../modules/logs_analytics_workspace"

  location            = local.location
  name                = "${local.environment_prefix}-log-analytics-workspace"
  resource_group_name = azurerm_resource_group.example.name
}

module "virtual_network_with_firewall" {
  source = "../modules/virtual_network"

  name                = "${local.environment_prefix}-virtual-network-with-firewall"
  location            = local.location
  resource_group_name = azurerm_resource_group.example.name

  address_space = ["10.3.0.0/16"]
  subnets       = {
    default = {
      address_prefixes = [
        "10.3.0.0/25"
      ]
    }
    AzureFirewallSubnet = {
      address_prefixes = [
        "10.3.0.128/25"
      ]
    }
  }

  log_analytics_workspace_id = module.log_analytics_workspace.id

  depends_on = [azurerm_resource_group.example, module.log_analytics_workspace]
}

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

module "route_table" {
  source = "../modules/route_table"

  name                = "${local.environment_prefix}-route-table"
  location            = local.location
  resource_group_name = azurerm_resource_group.example.name

  associated_subnets_ids = [module.virtual_network_with_firewall.subnets.default.id]
  routes                 = {
    default-to-firewall : {
      address_prefix         = "0.0.0.0/0"
      next_hop_type          = "VirtualAppliance"
      next_hop_in_ip_address = module.firewall.private_ip
    }
  }

  depends_on = [module.firewall]
}
```
<!-- END_TF_DOCS -->