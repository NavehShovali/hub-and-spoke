resource "azurerm_public_ip" "virtual_machine" {
  allocation_method   = "Static"
  location            = var.location
  name                = "${var.name}-public-ip"
  resource_group_name = var.resource_group_name
}

resource "azurerm_network_interface" "virtual_machine_nic" {
  name                = "${var.name}-nic"
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "${var.name}-ip"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.virtual_machine.id
  }
}

resource "azurerm_linux_virtual_machine" "linux_virtual_machine" {
  count = var.operating_system == "Linux" ? 1 : 0

  admin_password                  = var.admin_password
  admin_username                  = var.admin_username
  disable_password_authentication = false
  location                        = var.location
  name                            = var.name
  network_interface_ids           = [azurerm_network_interface.virtual_machine_nic.id]
  resource_group_name             = var.resource_group_name
  size                            = var.vm_size

  os_disk {
    caching              = "ReadWrite"
    name                 = "${var.name}-os-disk"
    storage_account_type = "Standard_LRS"
  }

  dynamic "source_image_reference" {
    for_each = var.storage_image_reference[*]
    content {
      publisher = source_image_reference.value.publisher
      offer     = source_image_reference.value.offer
      sku       = source_image_reference.value.sku
      version   = source_image_reference.value.version
    }
  }
}

resource "azurerm_windows_virtual_machine" "windows_virtual_machine" {
  count = var.operating_system == "Windows" ? 1 : 0

  admin_password        = var.admin_password
  admin_username        = var.admin_username
  location              = var.location
  name                  = var.name
  network_interface_ids = [azurerm_network_interface.virtual_machine_nic.id]
  resource_group_name   = var.resource_group_name
  size                  = var.vm_size

  os_disk {
    caching              = "ReadWrite"
    name                 = "${var.name}-os-disk"
    storage_account_type = "Standard_LRS"
  }

  dynamic "source_image_reference" {
    for_each = var.storage_image_reference[*]
    content {
      publisher = source_image_reference.value.publisher
      offer     = source_image_reference.value.offer
      sku       = source_image_reference.value.sku
      version   = source_image_reference.value.version
    }
  }
}

locals {
  virtual_machine = var.operating_system == coalesce(
    azurerm_linux_virtual_machine.linux_virtual_machine,
    azurerm_windows_virtual_machine.windows_virtual_machine
  )
}