variable "resource_group_name" {
  description = "Resource group to deploy to"
  type        = string
}

variable "location" {
  description = "Location to deploy to"
  type        = string
}

variable "name" {
  description = "The gateway's name"
  type        = string
}

variable "subnet_id" {
  description = "ID of the gateway subnet"
  type        = string
}

variable "azure_active_directory_authentication" {
  description = "Azure Active Directory credentials"
  sensitive   = true
  type        = object({
    audience = string
    issuer   = string
    tenant   = string
  })
}

variable "address_prefixes" {
  description = "Gateway connection addresses"
  type        = list(string)
}
