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
