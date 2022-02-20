variable "resource_group_name" {
  description = "Resource group to deploy to"
  type        = string
}

variable "location" {
  description = "Location to deploy to"
  type        = string
}

variable "name" {
  description = "The firewall's name"
  type        = string
}

variable "subnet_id" {
  description = "The id of the firewall's subnet"
  type        = string
}

variable "firewall_policy_id" {
  description = "The ID of the firewall policy associated with the firewall"
  type        = string
}

variable "public_ip_sku" {
  description = "Defines the SKU of the firewall's public IP resource"
  default     = "Standard"
}
