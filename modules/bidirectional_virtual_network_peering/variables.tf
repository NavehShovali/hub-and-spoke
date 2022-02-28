variable "virtual_networks_to_peer" {
  description = "Defines the necessary information about each of the two networks"
  type        = map(object({
    resource_group_name          = string
    name                         = string
    remote_id                    = string
    allow_gateway_transit        = bool
    use_remote_gateways          = bool
    allow_virtual_network_access = optional(bool)
    allow_forwarded_traffic      = optional(bool)
  }))
}
