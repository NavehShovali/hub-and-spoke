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
| [azurerm_monitor_diagnostic_setting.diagnostic_settings](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_diagnostic_setting) | resource |
| [azurerm_monitor_diagnostic_categories.resource_categories](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/monitor_diagnostic_categories) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_log_analytics_workspace_id"></a> [log\_analytics\_workspace\_id](#input\_log\_analytics\_workspace\_id) | The ID of the storage account to which logs should be sent | `string` | n/a | yes |
| <a name="input_target_resource_id"></a> [target\_resource\_id](#input\_target\_resource\_id) | The ID of the resource to monitor | `string` | n/a | yes |
| <a name="input_target_resource_name"></a> [target\_resource\_name](#input\_target\_resource\_name) | The diagnostic setting resource's name | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_id"></a> [id](#output\_id) | The ID of the created diagnostic settings resource |
| <a name="output_name"></a> [name](#output\_name) | The name of the created diagnostic settings resource |
| <a name="output_object"></a> [object](#output\_object) | The data object of the created diagnostic settings resource |
<!-- END_TF_DOCS -->