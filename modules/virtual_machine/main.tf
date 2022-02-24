resource "azurerm_network_interface" "virtual_machine_nic" {
  name                = "${var.name}-nic"
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "${var.name}-ip"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_linux_virtual_machine" "linux_virtual_machine" {
  count = var.is_linux ? 1 : 0

  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name

  network_interface_ids = [azurerm_network_interface.virtual_machine_nic.id]
  size                  = var.vm_size

  admin_password                  = var.admin_password
  admin_username                  = var.admin_username
  disable_password_authentication = false

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
  count = var.is_linux ? 0 : 1

  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name

  network_interface_ids = [azurerm_network_interface.virtual_machine_nic.id]
  size                  = var.vm_size

  admin_password = var.admin_password
  admin_username = var.admin_username

  os_disk {
    name                 = "${var.name}-os-disk"
    caching              = "ReadWrite"
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
  virtual_machine = coalesce(
    azurerm_linux_virtual_machine.linux_virtual_machine,
    azurerm_windows_virtual_machine.windows_virtual_machine
  )[0]
}

resource "azurerm_managed_disk" "virtual_machine_disks" {
  for_each = var.data_disks

  name                = "${local.virtual_machine.name}-${each.key}"
  location            = var.location
  resource_group_name = var.resource_group_name

  storage_account_type = each.value.storage_account_type
  create_option        = each.value.create_option
  disk_size_gb         = each.value.disk_size_gb
}

locals {
  name_to_data_disk = {for disk in azurerm_managed_disk.virtual_machine_disks : disk.name => disk}
}

resource "azurerm_virtual_machine_data_disk_attachment" "virtual_machine_disk_attachments" {
  for_each = var.data_disks

  virtual_machine_id = local.virtual_machine.id
  managed_disk_id    = local.name_to_data_disk["${local.virtual_machine.name}-${each.key}"].id
  caching            = each.value.caching
  lun                = each.value.lun
}
