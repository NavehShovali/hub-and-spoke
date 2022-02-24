variable "name" {
  description = "The diagnostic setting resource's name"
  type        = string
}

variable "target_resource_id" {
  description = "The ID of the resource to monitor"
  type        = string
}

variable "storage_account_id" {
  description = "The ID of the storage account to which logs should be sent"
  type        = string
}

variable "log_categories" {
  description = "The names of the diagnostic log categories"
  type        = list(string)
}
