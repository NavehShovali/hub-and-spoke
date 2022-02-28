<!-- BEGIN_TF_DOCS -->
# Virtual network

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
| <a name="module_virtual_network_diagnostic_settings"></a> [virtual\_network\_diagnostic\_settings](#module\_virtual\_network\_diagnostic\_settings) | ../diagnostic_settings | n/a |

## Resources

| Name | Type |
|------|------|
| [azurerm_subnet.subnets](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet) | resource |
| [azurerm_virtual_network.virtual_network](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_address_space"></a> [address\_space](#input\_address\_space) | The virtual network's address space | `list(string)` | n/a | yes |
| <a name="input_location"></a> [location](#input\_location) | Location to deploy to | `string` | n/a | yes |
| <a name="input_log_analytics_workspace_id"></a> [log\_analytics\_workspace\_id](#input\_log\_analytics\_workspace\_id) | The ID of the log analytics workspace to save logs to | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | The virtual network's name | `string` | n/a | yes |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | Resource group to deploy to | `string` | n/a | yes |
| <a name="input_subnets"></a> [subnets](#input\_subnets) | The subnets associated with the virtual network. Maps subnet names to their definition | <pre>map(object({<br>    address_prefixes                               = list(string)<br>    enforce_private_link_endpoint_network_policies = optional(bool)<br>  }))</pre> | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_id"></a> [id](#output\_id) | The ID of the virtual network |
| <a name="output_name"></a> [name](#output\_name) | The name of the virtual network |
| <a name="output_object"></a> [object](#output\_object) | The data object of the virtual network |
| <a name="output_subnets"></a> [subnets](#output\_subnets) | A map from name to data object of the virtual network's associated subnets |

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
```
<!-- END_TF_DOCS -->