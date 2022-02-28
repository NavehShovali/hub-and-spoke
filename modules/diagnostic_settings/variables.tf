variable "target_resource_name" {
  description = "The diagnostic setting resource's name"
  type        = string
}

variable "target_resource_id" {
  description = "The ID of the resource to monitor"
  type        = string
}

variable "log_analytics_workspace_id" {
  description = "The ID of the log analytics workspace to which logs should be sent"
  type        = string
  default     = null
}

variable "storage_account_id" {
  description = "The ID of the storage account to which logs should be sent"
  type        = string
  default     = null
}

variable "metrics" {
  description = "Defines the metric blocks"
  type        = list(string)
  default     = []
}
