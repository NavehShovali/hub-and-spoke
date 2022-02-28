<!-- BEGIN_TF_DOCS -->
# Bidirectional virtual network peering

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
| [azurerm_virtual_network_peering.peerings](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network_peering) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_virtual_networks_to_peer"></a> [virtual\_networks\_to\_peer](#input\_virtual\_networks\_to\_peer) | Defines the necessary information about each of the two networks | <pre>map(object({<br>    resource_group_name          = string<br>    name                         = string<br>    remote_id                    = string<br>    allow_gateway_transit        = bool<br>    use_remote_gateways          = bool<br>    allow_virtual_network_access = optional(bool)<br>    allow_forwarded_traffic      = optional(bool)<br>  }))</pre> | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_ids"></a> [ids](#output\_ids) | List of the IDs of each of the peerings |
| <a name="output_names"></a> [names](#output\_names) | List of the names of each of the peerings |
| <a name="output_objects"></a> [objects](#output\_objects) | List of the data objects of each of the peerings |

## Example

```hcl
locals {
  virtual_networks_to_peer = {
    virtual-network1 = {
      resource_group_name   = azurerm_resource_group.example.name
      name                  = module.virtual_network1.name
      remote_id             = module.virtual_network2.id
      allow_gateway_transit = true
      use_remote_gateways   = false
    }

    virtual-network2 = {
      resource_group_name   = azurerm_resource_group.example.name
      name                  = module.virtual_network2.name
      remote_id             = module.virtual_network1.id
      allow_gateway_transit = false
      use_remote_gateways   = true
    }
  }
}

module "peering" {
  source = "../modules/bidirectional_virtual_network_peering"

  virtual_networks_to_peer = local.virtual_networks_to_peer

  depends_on = [module.virtual_network1, module.virtual_network2]
}
```
<!-- END_TF_DOCS -->