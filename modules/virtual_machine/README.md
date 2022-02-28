<!-- BEGIN_TF_DOCS -->
# Virtual machine

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
| <a name="module_virtual_machine_diagnostic_settings"></a> [virtual\_machine\_diagnostic\_settings](#module\_virtual\_machine\_diagnostic\_settings) | ../diagnostic_settings | n/a |

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
| <a name="input_log_analytics_workspace_id"></a> [log\_analytics\_workspace\_id](#input\_log\_analytics\_workspace\_id) | The ID of the log analytics workspace to save logs to | `string` | n/a | yes |
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

module "log_analytics_workspace" {
  source = "../modules/logs_analytics_workspace"

  location            = local.location
  name                = "${local.environment_prefix}-log-analytics-workspace"
  resource_group_name = azurerm_resource_group.example.name
}

variable "virtual_machine_admin_password" {
  description = "Default password value of a virtual machine admin user"
  type        = string
  sensitive   = true
}

module "spoke_virtual_machine" {
  source = "../modules/virtual_machine"

  name                = "${local.environment_prefix}-virtual-machine"
  location            = local.location
  resource_group_name = azurerm_resource_group.example.name

  storage_image_reference = {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }

  is_linux  = true
  vm_size   = "Standard_DS1_v2"
  subnet_id = module.virtual_network1.subnets.default.id

  admin_password = var.virtual_machine_admin_password
  admin_username = "admin"

  log_analytics_workspace_id = module.log_analytics_workspace.id

  depends_on = [module.virtual_network1, module.log_analytics_workspace]
}
```
<!-- END_TF_DOCS -->