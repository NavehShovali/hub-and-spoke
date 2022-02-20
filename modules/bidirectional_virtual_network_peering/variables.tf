variable "resource_group_name" {
  description = "Resource group to deploy to"
  type        = string
}

variable "virtual_networks_to_peer" {
  description = "Defines the necessary information about each of the two networks"
  type        = map(object({
    name                  = string
    remote_id             = string
    allow_gateway_transit = bool
    use_remote_gateways   = bool
  }))
}