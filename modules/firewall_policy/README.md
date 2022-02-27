<!-- BEGIN_TF_DOCS -->
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
| [azurerm_firewall_policy.firewall_policy](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/firewall_policy) | resource |
| [azurerm_firewall_policy_rule_collection_group.rule_collections](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/firewall_policy_rule_collection_group) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_location"></a> [location](#input\_location) | Location to deploy to | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | The firewall's name | `string` | n/a | yes |
| <a name="input_policy_rule_collection_groups"></a> [policy\_rule\_collection\_groups](#input\_policy\_rule\_collection\_groups) | Defines the firewall policy's rules | <pre>map(object({<br>    priority                 = number<br>    network_rule_collections = optional(map(object({<br>      action   = string<br>      priority = number<br>      rules    = map(object({<br>        protocols             = list(string)<br>        source_addresses      = list(string)<br>        destination_addresses = list(string)<br>        destination_ports     = list(string)<br>      }))<br>    })))<br>    nat_rule_collections = optional(map(object({<br>      action   = string<br>      priority = number<br>      rules    = map(object({<br>        protocols           = list(string)<br>        source_addresses    = list(string)<br>        destination_address = string<br>        destination_ports   = list(string)<br>        translated_address  = string<br>        translated_port     = string<br>      }))<br>    })))<br>    application_rule_collection = optional(map(object({<br>      action   = string<br>      priority = number<br>      rules    = map(object({<br>        source_addresses       = optional(list(string))<br>        source_ip_groups       = optional(list(string))<br>        destination_addresses  = list(string)<br>        destination_urls       = list(string)<br>        destination_fqdn       = list(string)<br>        destination_fqdns_tags = list(string)<br>        terminate_tls          = bool<br>        web_categories         = list(string)<br>        protocols              = optional(map(number))<br>      }))<br>    })))<br>  }))</pre> | n/a | yes |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | Resource group to deploy to | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_id"></a> [id](#output\_id) | The ID of the firewall policy |
| <a name="output_name"></a> [name](#output\_name) | The name of the firewall policy |
| <a name="output_object"></a> [object](#output\_object) | The data object of the firewall policy |
<!-- END_TF_DOCS -->