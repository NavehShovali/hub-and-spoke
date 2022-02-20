variable "resource_group_name" {
  description = "Resource group to deploy to"
  type        = string
}

variable "location" {
  description = "Location to deploy to"
  type        = string
}

variable "name" {
  description = "The virtual machine's name"
  type        = string
}

variable "subnet_id" {
  type        = string
  description = "The id of the subnet the virtual machine is associated with"
}

variable "vm_size" {
  description = "Virtual machine size"
  type        = string
}

variable "storage_image_reference" {
  description = "The virtual machine's storage image reference block"
  type        = object({
    publisher = string
    offer     = string
    sku       = string
    version   = string
  })
}

variable "os_profile" {
  description = "The virtual machine's OS profile"
  type        = object({
    computer_name  = string
    admin_username = string
  })
}

variable "admin_password" {
  description = "Defines the default password to be assigned to the OS profile"
  type        = string
  sensitive   = true
}
