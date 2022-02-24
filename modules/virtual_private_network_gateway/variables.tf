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

variable "public_ip_allocation_method" {
  description = "Defines the public IP's allocation method. Possible values are 'Dynamic' or 'Static'"
  default     = "Dynamic"
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

variable "generation" {
  description = "The Generation of the Virtual Network gateway. Defaults to `Generation2`"
  default     = "Generation2"
}

variable "sku" {
  description = "Configuration of the size and capacity of the virtual network gateway. Defaults to `VpnGw2`"
  default     = "VpnGw2"
}

variable "type" {
  description = "The type of the Virtual Network Gateway. Defaults to `Vpn`"
  default     = "Vpn"
}

variable "vpn_type" {
  description = "The routing type of the Virtual Network Gateway. Defaults to `RouteBased`"
  default     = "RouteBased"
}

variable "vpn_client_protocols" {
  description = "List of the protocols supported by the vpn client. Defaults to `['OpenVPN']`"
  default     = ["OpenVPN"]
}

variable "vpn_auth_types" {
  description = "List of the vpn authentication types for the virtual network gateway. Defaults to `['AAD']`"
  default     = ["AAD"]
}
