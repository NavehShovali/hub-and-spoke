<!-- BEGIN_TF_DOCS -->
# Logs analytics workspace

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
| [azurerm_log_analytics_workspace.log_analytics_workspace](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/log_analytics_workspace) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_location"></a> [location](#input\_location) | Location to deploy to | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | The name of the workspace | `string` | n/a | yes |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | Resource group to deploy to | `string` | n/a | yes |
| <a name="input_retention_in_days"></a> [retention\_in\_days](#input\_retention\_in\_days) | The workspace data retention in days. Defaults to 30 | `number` | `30` | no |
| <a name="input_sku"></a> [sku](#input\_sku) | Specifies the Sku of the Log Analytics Workspace. Defaults to 'PerGB2018' | `string` | `"PerGB2018"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_id"></a> [id](#output\_id) | The ID of the created workspace |
| <a name="output_name"></a> [name](#output\_name) | The name of the created workspace |
| <a name="output_object"></a> [object](#output\_object) | The data object of the created workspace |

## Example

```hcl
module "log_analytics_workspace" {
  source = "../modules/logs_analytics_workspace"

  location            = "westeurope"
  name                = "example-log-analytics-workspace"
  resource_group_name = azurerm_resource_group.example.name
}
```
<!-- END_TF_DOCS -->