variable "resource_group_name" {
  description = "Resource group to deploy to"
  type        = string
}

variable "location" {
  description = "Location to deploy to"
  type        = string
}

variable "name" {
  description = "The route table's name"
  type        = string
}

variable "firewall_internal_ip" {
  description = "The internal IP address of the firewall"
  type        = string
}

variable "routes" {
  description = "The route table's route definitions"
  type        = list(object({
    name           = string
    address_prefix = string
  }))
}

variable "associated_subnets_ids" {
  description = "List of the IDs of the subnets associated with the route table"
  type        = list(string)
}