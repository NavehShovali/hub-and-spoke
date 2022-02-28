variable "virtual_machine_admin_password" {
  description = "Default password value of a virtual machine admin user"
  type        = string
  sensitive   = true
}

module "spoke_virtual_machine" {
  source = "../modules/virtual_machine"

  name                = "example-virtual-machine"
  location            = "westeurope"
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