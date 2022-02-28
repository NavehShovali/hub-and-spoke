<!-- BEGIN_TF_DOCS -->
# Diagnostic settings

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
| <a name="input_log_analytics_workspace_id"></a> [log\_analytics\_workspace\_id](#input\_log\_analytics\_workspace\_id) | The ID of the log analytics workspace to which logs should be sent | `string` | `null` | no |
| <a name="input_metrics"></a> [metrics](#input\_metrics) | Defines the metric blocks | `list(string)` | `[]` | no |
| <a name="input_storage_account_id"></a> [storage\_account\_id](#input\_storage\_account\_id) | The ID of the storage account to which logs should be sent | `string` | `null` | no |
| <a name="input_target_resource_id"></a> [target\_resource\_id](#input\_target\_resource\_id) | The ID of the resource to monitor | `string` | n/a | yes |
| <a name="input_target_resource_name"></a> [target\_resource\_name](#input\_target\_resource\_name) | The diagnostic setting resource's name | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_id"></a> [id](#output\_id) | The ID of the created diagnostic settings resource |
| <a name="output_name"></a> [name](#output\_name) | The name of the created diagnostic settings resource |
| <a name="output_object"></a> [object](#output\_object) | The data object of the created diagnostic settings resource |

## Example

```hcl
module "virtual_network_diagnostic_settings" {
  source = "../modules/diagnostic_settings"

  log_analytics_workspace_id = module.log_analytics_workspace.id
  target_resource_name       = module.virtual_network1.name
  target_resource_id         = module.virtual_network1.id

  depends_on = [module.log_analytics_workspace, module.virtual_network1]
}
```
<!-- END_TF_DOCS -->