variable "azure_active_directory_authentication" {
  description = "The virtual private network's AAD credentials"
  sensitive   = true
  type        = object({
    audience = string
    issuer   = string
    tenant   = string
  })
}

variable "virtual_machine_admin_password" {
  description = "Default password value of a virtual machine admin user"
  type        = string
  sensitive   = true
}
