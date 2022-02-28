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

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_public_ip.gateway_ips](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/public_ip) | resource |
| [azurerm_virtual_network_gateway.gateway](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network_gateway) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_active_active"></a> [active\_active](#input\_active\_active) | If true, an active-active Virtual Network Gateway will be created. Otherwise, an active-standby gateway will be created | `bool` | `false` | no |
| <a name="input_address_prefixes"></a> [address\_prefixes](#input\_address\_prefixes) | Gateway connection addresses | `list(string)` | n/a | yes |
| <a name="input_azure_active_directory_authentication"></a> [azure\_active\_directory\_authentication](#input\_azure\_active\_directory\_authentication) | Azure Active Directory credentials | <pre>object({<br>    audience = string<br>    issuer   = string<br>    tenant   = string<br>  })</pre> | n/a | yes |
| <a name="input_generation"></a> [generation](#input\_generation) | The Generation of the Virtual Network gateway. Defaults to `Generation2` | `string` | `"Generation2"` | no |
| <a name="input_location"></a> [location](#input\_location) | Location to deploy to | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | The gateway's name | `string` | n/a | yes |
| <a name="input_public_ip_allocation_method"></a> [public\_ip\_allocation\_method](#input\_public\_ip\_allocation\_method) | Defines the public IP's allocation method. Possible values are 'Dynamic' or 'Static' | `string` | `"Dynamic"` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | Resource group to deploy to | `string` | n/a | yes |
| <a name="input_sku"></a> [sku](#input\_sku) | Configuration of the size and capacity of the virtual network gateway. Defaults to `VpnGw2` | `string` | `"VpnGw2"` | no |
| <a name="input_subnet_id"></a> [subnet\_id](#input\_subnet\_id) | ID of the gateway subnet | `string` | n/a | yes |
| <a name="input_type"></a> [type](#input\_type) | The type of the Virtual Network Gateway. Defaults to `Vpn` | `string` | `"Vpn"` | no |
| <a name="input_vpn_auth_types"></a> [vpn\_auth\_types](#input\_vpn\_auth\_types) | List of the vpn authentication types for the virtual network gateway. Defaults to `['AAD']` | `list(string)` | <pre>[<br>  "AAD"<br>]</pre> | no |
| <a name="input_vpn_client_protocols"></a> [vpn\_client\_protocols](#input\_vpn\_client\_protocols) | List of the protocols supported by the vpn client. Defaults to `['OpenVPN']` | `list(string)` | <pre>[<br>  "OpenVPN"<br>]</pre> | no |
| <a name="input_vpn_type"></a> [vpn\_type](#input\_vpn\_type) | The routing type of the Virtual Network Gateway. Defaults to `RouteBased` | `string` | `"RouteBased"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_id"></a> [id](#output\_id) | The ID of the VPN gateway |
| <a name="output_name"></a> [name](#output\_name) | The name of the VPN gateway |
| <a name="output_object"></a> [object](#output\_object) | The data object of the VPN gateway |

## Example

```hcl
module "virtual_private_network_gateway" {
  source = "../modules/virtual_private_network_gateway"

  name                = "example-vpn"
  location            = "westeurope"
  resource_group_name = azurerm_resource_group.example.name

  address_prefixes                      = ["10.2.0.0/24"]
  azure_active_directory_authentication = var.azure_active_directory_authentication
  subnet_id                             = module.virtual_network_with_gateway.subnets.GatewaySubnet.id

  depends_on = [module.virtual_network_with_gateway]
}
```
<!-- END_TF_DOCS -->