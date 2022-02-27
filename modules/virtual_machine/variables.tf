variable "resource_group_name" {
  description = "Resource group to deploy to"
  type        = string
}

variable "location" {
  description = "Location to deploy to"
  type        = string
}

variable "is_linux" {
  description = "Defines the operating system. If true, a Linux VM will be instantiated. Otherwise, the OS would be Windows"
  type        = bool
}

variable "name" {
  description = "The virtual machine's name"
  type        = string

  validation {
    condition     = length(var.name) <= 15
    error_message = "Virtual machines' names cannot be longer than 15 characters."
  }
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

variable "admin_password" {
  description = "Defines the default password to be assigned to the OS profile"
  type        = string
  sensitive   = true
}

variable "admin_username" {
  description = "Defines the virtual machine's admin username"
  type        = string
}

variable "data_disks" {
  description = "A map from name to data object of the data disks to attach to the virtual machine (optional)"
  default     = {}
  type        = map(object({
    storage_account_type = string
    create_option        = string
    disk_size_gb         = number
    lun                  = number
    caching              = string
  }))
}

variable "storage_account_id" {
  description = "The ID of the storage account to save logs to"
  type        = string
}
