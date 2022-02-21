variable "resource_group_name" {
  description = "Resource group to deploy to"
  type        = string
}

variable "location" {
  description = "Location to deploy to"
  type        = string
}

variable "name" {
  description = "The storage account's name"
  type        = string
}

variable "account_replication_type" {
  description = "Defines the type of replication to use for the storage account"
  type        = string
  default     = "RAGRS"
}

variable "account_tier" {
  description = "Defines the tier to use for the storage account"
  type        = string
  default     = "Standard"
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
