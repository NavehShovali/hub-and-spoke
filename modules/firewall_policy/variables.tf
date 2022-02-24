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

variable "policy_rule_collection_groups" {
  description = "Defines the firewall policy's rules"
  type        = map(object({
    priority                 = number
    network_rule_collections = optional(map(object({
      action   = string
      priority = number
      rules    = map(object({
        protocols             = list(string)
        source_addresses      = list(string)
        destination_addresses = list(string)
        destination_ports     = list(string)
      }))
    })))
    nat_rule_collections = optional(map(object({
      action   = string
      priority = number
      rules    = map(object({
        protocols             = list(string)
        source_addresses      = list(string)
        destination_addresses = list(string)
        destination_ports     = list(string)
        translated_address    = string
        translated_port       = string
      }))
    })))
    application_rule_collection = optional(map(object({
      action   = string
      priority = number
      rules    = map(object({
        protocols              = optional(list(string))
        source_addresses       = optional(list(string))
        source_ip_groups       = optional(list(string))
        destination_addresses  = list(string)
        destination_urls       = list(string)
        destination_fqdns      = list(string)
        destination_fqdns_tags = list(string)
        terminate_tls          = bool
        web_categories         = list(string)
      }))
    })))
  }))
}
