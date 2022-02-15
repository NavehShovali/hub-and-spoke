variable "resource_group_name" {
  description = "Resource group to deploy to"
  type        = string
}

variable "location" {
  description = "Location to deploy to"
  type        = string
}

variable "name" {
  description = "The virtual network's name"
  type        = string
}

variable "account_replication_type" {
  description = "Defines the type of replication to use for the storage account"
  type = string
  default = "RAGRS"
}

variable "account_tier" {
  description = "Defines the tier to use for the storage account"
  type = string
  default = "Standard"
}
