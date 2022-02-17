variable "resource_group_name" {
  description = "Resource group to deploy to"
  type        = string
}

variable "virtual_network_name" {
  description = "The name of the virtual networks to peer from"
  type        = string
}

variable "remote_virtual_network_name" {
  description = "The name of the remote virtual networks to peer to"
  type        = string
}

variable "remote_virtual_network_id" {
  description = "The ID of the remote virtual networks to peer to"
  type        = string
}

variable "allow_gateway_transit" {
  description = "Controls if forwarded traffic from gateway in the remote virtual network is allowed"
  type        = bool
}

variable "use_remote_gateways" {
  description = "Controls if gateway can be used in the remote virtual network’s link to the local virtual network"
  type        = bool
}
