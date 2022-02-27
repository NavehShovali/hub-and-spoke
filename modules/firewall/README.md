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

| Name | Source | Version |
|------|--------|---------|
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
<!-- END_TF_DOCS -->