<!-- BEGIN_TF_DOCS -->
# Network security group

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
| [azurerm_network_security_group.security_group](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_group) | resource |
| [azurerm_subnet_network_security_group_association.security_group_association](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet_network_security_group_association) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_location"></a> [location](#input\_location) | Location to deploy to | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | Resource group to use | `string` | n/a | yes |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | Resource group to deploy to | `string` | n/a | yes |
| <a name="input_security_rules"></a> [security\_rules](#input\_security\_rules) | Network security rules. Note that if a range/prefix parameter is null, its corresponding ranges/prefixes parameter must not be null, and vice versa. | <pre>map(object({<br>    access                       = string<br>    direction                    = string<br>    priority                     = number<br>    protocol                     = string<br>    source_port_range            = optional(string)<br>    destination_port_range       = optional(string)<br>    source_address_prefix        = optional(string)<br>    destination_address_prefix   = optional(string)<br>    source_port_ranges           = optional(list(string))<br>    destination_port_ranges      = optional(list(string))<br>    source_address_prefixes      = optional(list(string))<br>    destination_address_prefixes = optional(list(string))<br>  }))</pre> | n/a | yes |
| <a name="input_subnet_id"></a> [subnet\_id](#input\_subnet\_id) | The subnet to associate the NSG with | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_id"></a> [id](#output\_id) | The ID of the network security group |
| <a name="output_name"></a> [name](#output\_name) | The name of the network security group |
| <a name="output_object"></a> [object](#output\_object) | The data object of the network security group |

## Example

```hcl
locals {
  security_rules = {
    allow-ssh-to-default = {
      access                     = "Allow"
      direction                  = "Inbound"
      priority                   = 300
      protocol                   = "TCP"
      source_port_range          = "*"
      destination_port_range     = "22"
      source_address_prefix      = "10.0.0.0/16"
      destination_address_prefix = "10.0.0.0/25"
    }
  }
}

module "example_network_security_group" {
  source = "../modules/network_security_group"

  name                = "example-network-security-group"
  location            = "westeurope"
  resource_group_name = azurerm_resource_group.example.name

  security_rules = local.security_rules
  subnet_id      = module.virtual_network1.subnets.default.id

  depends_on = [module.virtual_network1]
}
```
<!-- END_TF_DOCS -->