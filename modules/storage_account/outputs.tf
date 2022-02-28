output "id" {
  description = "The ID of the storage account"
  value       = azurerm_storage_account.storage_account.id
}

output "name" {
  description = "The name of the storage account"
  value       = azurerm_storage_account.storage_account.name
}

output "object" {
  description = "The data object of the storage account"
  value       = azurerm_storage_account.storage_account
}
