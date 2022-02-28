variable "azure_active_directory_authentication" {
  description = "The virtual private network's AAD credentials"
  sensitive   = true
  type        = object({
    audience = string
    issuer   = string
    tenant   = string
  })
}
