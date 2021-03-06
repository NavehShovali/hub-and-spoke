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

variable "public_ip_sku" {
  description = "Defines the SKU of the firewall's public IP resource"
  type        = string
  default     = "Standard"
}

variable "policy_rule_collection_groups" {
  description = "Defines the firewall policy's rules"
  type        = map(object({
    priority                 = number
    network_rule_collections = map(object({
      action   = string
      priority = number
      rules    = map(object({
        protocols             = list(string)
        source_addresses      = list(string)
        destination_addresses = list(string)
        destination_ports     = list(string)
      }))
    }))
  }))
}

variable "private_ip_ranges" {
  description = "The ranges of addresses from which the firewall's private IP will be allocated"
  type        = list(string)
}

variable "log_analytics_workspace_id" {
  description = "The ID of the log analytics workspace to save logs to"
  type        = string
}
