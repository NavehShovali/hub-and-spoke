resource "azurerm_public_ip" "virtual_machine" {
  allocation_method   = "Static"
  location            = var.location
  name                = "${var.name}-public-ip"
  resource_group_name = var.resource_group_name
}

resource "azurerm_network_interface" "virtual_machine" {
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

resource "azurerm_virtual_machine" "virtual_machine" {
  location              = var.location
  name                  = var.name
  network_interface_ids = [azurerm_network_interface.virtual_machine.id]
  resource_group_name   = var.resource_group_name
  vm_size               = var.vm_size

  storage_os_disk {
    create_option     = "FromImage"
    name              = "${var.name}-os-disk"
    caching           = "ReadWrite"
    managed_disk_type = "Standard_LRS"
  }

  dynamic "storage_image_reference" {
    for_each = var.storage_image_reference[*]
    content {
      publisher = storage_image_reference.value.publisher
      offer     = storage_image_reference.value.offer
      sku       = storage_image_reference.value.sku
      version   = storage_image_reference.value.version
    }
  }

  dynamic "os_profile" {
    for_each = var.os_profile[*]
    content {
      computer_name  = os_profile.value.computer_name
      admin_username = os_profile.value.admin_username
      admin_password = coalesce(os_profile.value.admin_password, var.default_admin_password)
    }
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }
}
