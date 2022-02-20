output "ids" {
  value = [for peering in values(azurerm_virtual_network_peering.peerings) : peering.id]
}

output "names" {
  value = [for peering in values(azurerm_virtual_network_peering.peerings) : peering.name]
}

output "objects" {
  value = values(azurerm_virtual_network_peering.peerings)
}
