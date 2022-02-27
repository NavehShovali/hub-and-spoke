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
| [azurerm_linux_virtual_machine.linux_virtual_machine](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/linux_virtual_machine) | resource |
| [azurerm_managed_disk.virtual_machine_disks](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/managed_disk) | resource |
| [azurerm_network_interface.virtual_machine_nic](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_interface) | resource |
| [azurerm_virtual_machine_data_disk_attachment.virtual_machine_disk_attachments](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_machine_data_disk_attachment) | resource |
| [azurerm_windows_virtual_machine.windows_virtual_machine](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/windows_virtual_machine) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_admin_password"></a> [admin\_password](#input\_admin\_password) | Defines the default password to be assigned to the OS profile | `string` | n/a | yes |
| <a name="input_admin_username"></a> [admin\_username](#input\_admin\_username) | Defines the virtual machine's admin username | `string` | n/a | yes |
| <a name="input_data_disks"></a> [data\_disks](#input\_data\_disks) | A map from name to data object of the data disks to attach to the virtual machine (optional) | <pre>map(object({<br>    storage_account_type = string<br>    create_option        = string<br>    disk_size_gb         = number<br>    lun                  = number<br>    caching              = string<br>  }))</pre> | `{}` | no |
| <a name="input_is_linux"></a> [is\_linux](#input\_is\_linux) | Defines the operating system. If true, a Linux VM will be instantiated. Otherwise, the OS would be Windows | `bool` | n/a | yes |
| <a name="input_location"></a> [location](#input\_location) | Location to deploy to | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | The virtual machine's name | `string` | n/a | yes |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | Resource group to deploy to | `string` | n/a | yes |
| <a name="input_storage_image_reference"></a> [storage\_image\_reference](#input\_storage\_image\_reference) | The virtual machine's storage image reference block | <pre>object({<br>    publisher = string<br>    offer     = string<br>    sku       = string<br>    version   = string<br>  })</pre> | n/a | yes |
| <a name="input_subnet_id"></a> [subnet\_id](#input\_subnet\_id) | The id of the subnet the virtual machine is associated with | `string` | n/a | yes |
| <a name="input_vm_size"></a> [vm\_size](#input\_vm\_size) | Virtual machine size | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_id"></a> [id](#output\_id) | The ID of the created virtual machine |
| <a name="output_name"></a> [name](#output\_name) | The name of the created virtual machine |
| <a name="output_object"></a> [object](#output\_object) | The data object of the created virtual machine |
<!-- END_TF_DOCS -->