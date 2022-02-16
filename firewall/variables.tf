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
