# Hub and Spoke Architecture

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.1.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | ~> 2.97 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | 2.97.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_firewall_diagnostic_settings"></a> [firewall\_diagnostic\_settings](#module\_firewall\_diagnostic\_settings) | ./modules/diagnostic_settings | n/a |
| <a name="module_hub_firewall"></a> [hub\_firewall](#module\_hub\_firewall) | ./modules/firewall | n/a |
| <a name="module_hub_route_table"></a> [hub\_route\_table](#module\_hub\_route\_table) | ./modules/route_table | n/a |
| <a name="module_hub_virtual_network"></a> [hub\_virtual\_network](#module\_hub\_virtual\_network) | ./modules/virtual_network | n/a |
| <a name="module_hub_virtual_private_network_gateway"></a> [hub\_virtual\_private\_network\_gateway](#module\_hub\_virtual\_private\_network\_gateway) | ./modules/virtual_private_network_gateway | n/a |
| <a name="module_hub_vnet_diagnostic_settings"></a> [hub\_vnet\_diagnostic\_settings](#module\_hub\_vnet\_diagnostic\_settings) | ./modules/diagnostic_settings | n/a |
| <a name="module_log_analytics_workspace"></a> [log\_analytics\_workspace](#module\_log\_analytics\_workspace) | ./modules/logs_analytics_workspace | n/a |
| <a name="module_peer_hub_and_spoke"></a> [peer\_hub\_and\_spoke](#module\_peer\_hub\_and\_spoke) | ./modules/bidirectional_virtual_network_peering | n/a |
| <a name="module_spoke_network_security_group"></a> [spoke\_network\_security\_group](#module\_spoke\_network\_security\_group) | ./modules/network_security_group | n/a |
| <a name="module_spoke_route_table"></a> [spoke\_route\_table](#module\_spoke\_route\_table) | ./modules/route_table | n/a |
| <a name="module_spoke_storage_account"></a> [spoke\_storage\_account](#module\_spoke\_storage\_account) | ./modules/storage_account | n/a |
| <a name="module_spoke_storage_account_private_endpoint"></a> [spoke\_storage\_account\_private\_endpoint](#module\_spoke\_storage\_account\_private\_endpoint) | ./modules/private_endpoint | n/a |
| <a name="module_spoke_virtual_machine"></a> [spoke\_virtual\_machine](#module\_spoke\_virtual\_machine) | ./modules/virtual_machine | n/a |
| <a name="module_spoke_virtual_network"></a> [spoke\_virtual\_network](#module\_spoke\_virtual\_network) | ./modules/virtual_network | n/a |
| <a name="module_spoke_vnet_diagnostic_settings"></a> [spoke\_vnet\_diagnostic\_settings](#module\_spoke\_vnet\_diagnostic\_settings) | ./modules/diagnostic_settings | n/a |

## Resources

| Name | Type |
|------|------|
| [azurerm_resource_group.common](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group) | resource |
| [azurerm_resource_group.hub](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group) | resource |
| [azurerm_resource_group.spoke](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_azure_active_directory_authentication"></a> [azure\_active\_directory\_authentication](#input\_azure\_active\_directory\_authentication) | The virtual private network's AAD credentials | <pre>object({<br>    audience = string<br>    issuer   = string<br>    tenant   = string<br>  })</pre> | n/a | yes |
| <a name="input_virtual_machine_admin_password"></a> [virtual\_machine\_admin\_password](#input\_virtual\_machine\_admin\_password) | Default password value of a virtual machine admin user | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->