<!-- BEGIN_TF_DOCS -->
# Firewall

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

| Name | Source | Version |
|------|--------|---------|
| <a name="module_firewall_diagnostic_settings"></a> [firewall\_diagnostic\_settings](#module\_firewall\_diagnostic\_settings) | ../diagnostic_settings | n/a |
| <a name="module_hub_firewall_policy"></a> [hub\_firewall\_policy](#module\_hub\_firewall\_policy) | ../firewall_policy | n/a |

## Resources

| Name | Type |
|------|------|
| [azurerm_firewall.firewall](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/firewall) | resource |
| [azurerm_public_ip.public_ip](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/public_ip) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_location"></a> [location](#input\_location) | Location to deploy to | `string` | n/a | yes |
| <a name="input_log_analytics_workspace_id"></a> [log\_analytics\_workspace\_id](#input\_log\_analytics\_workspace\_id) | The ID of the log analytics workspace to save logs to | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | The firewall's name | `string` | n/a | yes |
| <a name="input_policy_rule_collection_groups"></a> [policy\_rule\_collection\_groups](#input\_policy\_rule\_collection\_groups) | Defines the firewall policy's rules | <pre>map(object({<br>    priority                 = number<br>    network_rule_collections = map(object({<br>      action   = string<br>      priority = number<br>      rules    = map(object({<br>        protocols             = list(string)<br>        source_addresses      = list(string)<br>        destination_addresses = list(string)<br>        destination_ports     = list(string)<br>      }))<br>    }))<br>  }))</pre> | n/a | yes |
| <a name="input_private_ip_ranges"></a> [private\_ip\_ranges](#input\_private\_ip\_ranges) | The ranges of addresses from which the firewall's private IP will be allocated | `list(string)` | n/a | yes |
| <a name="input_public_ip_sku"></a> [public\_ip\_sku](#input\_public\_ip\_sku) | Defines the SKU of the firewall's public IP resource | `string` | `"Standard"` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | Resource group to deploy to | `string` | n/a | yes |
| <a name="input_subnet_id"></a> [subnet\_id](#input\_subnet\_id) | The id of the firewall's subnet | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_id"></a> [id](#output\_id) | The ID of the firewall |
| <a name="output_name"></a> [name](#output\_name) | The name of the firewall |
| <a name="output_object"></a> [object](#output\_object) | The data object the firewall |
| <a name="output_policy_object"></a> [policy\_object](#output\_policy\_object) | The data object of the firewall policy associated with the firewall |
| <a name="output_private_ip"></a> [private\_ip](#output\_private\_ip) | The private IP address of the firewall |

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
```
<!-- END_TF_DOCS -->