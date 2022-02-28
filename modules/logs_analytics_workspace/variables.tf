variable "resource_group_name" {
  description = "Resource group to deploy to"
  type        = string
}

variable "location" {
  description = "Location to deploy to"
  type        = string
}

variable "name" {
  description = "The name of the workspace"
  type        = string
}

variable "sku" {
  description = "Specifies the Sku of the Log Analytics Workspace. Defaults to 'PerGB2018'"
  type        = string
  default     = "PerGB2018"
}

variable "retention_in_days" {
  description = "The workspace data retention in days. Defaults to 30"
  default     = 30
}
