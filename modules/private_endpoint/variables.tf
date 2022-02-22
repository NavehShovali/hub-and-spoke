variable "resource_group_name" {
  description = "Resource group to deploy to"
  type        = string
}

variable "location" {
  description = "Location to deploy to"
  type        = string
}

variable "name" {
  description = "The private endpoint's name"
  type        = string
}

variable "subnet_id" {
  description = "The id of the subnet to connect the private endpoint to"
  type        = string
}

variable "connection_subresources_names" {
  description = "Defines the sub-resources of the private service connection"
  type        = list(string)
  default     = ["blob"]
}

variable "private_connection_resource_id" {
  description = "Defines the ID of the resource to connect to"
  type        = string
}

variable "is_manual_connection" {
  description = "Defines whether the private service connection is manual. Defaults to false"
  default     = false
}
