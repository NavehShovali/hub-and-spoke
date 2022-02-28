output "ids" {
  description = "List of the IDs of each of the peerings"
  value       = [for peering in values(azurerm_virtual_network_peering.peerings) : peering.id]
}

output "names" {
  description = "List of the names of each of the peerings"
  value       = [for peering in values(azurerm_virtual_network_peering.peerings) : peering.name]
}

output "objects" {
  description = "List of the data objects of each of the peerings"
  value       = values(azurerm_virtual_network_peering.peerings)
}
