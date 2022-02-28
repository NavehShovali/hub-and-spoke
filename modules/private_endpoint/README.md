<!-- BEGIN_TF_DOCS -->
# Private endpoint

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
| [azurerm_private_endpoint.private_endpoint](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_endpoint) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_connection_subresources_names"></a> [connection\_subresources\_names](#input\_connection\_subresources\_names) | Defines the sub-resources of the private service connection | `list(string)` | <pre>[<br>  "blob"<br>]</pre> | no |
| <a name="input_is_manual_connection"></a> [is\_manual\_connection](#input\_is\_manual\_connection) | Defines whether the private service connection is manual. Defaults to false | `bool` | `false` | no |
| <a name="input_location"></a> [location](#input\_location) | Location to deploy to | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | The private endpoint's name | `string` | n/a | yes |
| <a name="input_private_connection_resource_id"></a> [private\_connection\_resource\_id](#input\_private\_connection\_resource\_id) | Defines the ID of the resource to connect to | `string` | n/a | yes |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | Resource group to deploy to | `string` | n/a | yes |
| <a name="input_subnet_id"></a> [subnet\_id](#input\_subnet\_id) | The id of the subnet to connect the private endpoint to | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_id"></a> [id](#output\_id) | The ID of the private endpoint |
| <a name="output_name"></a> [name](#output\_name) | The name of the private endpoint |
| <a name="output_object"></a> [object](#output\_object) | The data object of the private endpoint |

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

module "virtual_network1" {
  source = "../modules/virtual_network"

  name                = "${local.environment_prefix}-virtual-network1"
  location            = local.location
  resource_group_name = azurerm_resource_group.example.name

  address_space = ["10.0.0.0/16"]
  subnets       = {
    default = {
      address_prefixes = [
        "10.0.0.0/25"
      ]
    }
  }

  log_analytics_workspace_id = module.log_analytics_workspace.id

  depends_on = [azurerm_resource_group.example, module.log_analytics_workspace]
}

module "storage_account" {
  source = "../modules/storage_account"

  name                = "${local.environment_prefix}-storage-account"
  location            = local.location
  resource_group_name = azurerm_resource_group.example.name

  depends_on = [azurerm_resource_group.example]
}

module "storage_account_private_endpoint" {
  source = "../modules/private_endpoint"

  name                = "${local.environment_prefix}-private-endpoint"
  location            = local.location
  resource_group_name = azurerm_resource_group.example.name

  private_connection_resource_id = module.storage_account.id
  subnet_id                      = module.virtual_network1.subnets.default.id

  depends_on = [module.virtual_network1, module.storage_account]
}
```
<!-- END_TF_DOCS -->