resource "azurerm_route_table" "route_table" {
  location            = var.location
  name                = var.name
  resource_group_name = var.resource_group_name

  dynamic "route" {
    for_each = var.routes
    content {
      address_prefix         = route.value.address_prefix
      name                   = route.value.name
      next_hop_type          = route.value.next_hop_type
      next_hop_in_ip_address = route.value.next_hop_in_ip_address
    }
  }
}

resource "azurerm_subnet_route_table_association" "route_table" {
  for_each       = toset(var.associated_subnets_ids)
  route_table_id = azurerm_route_table.route_table.id
  subnet_id      = each.key
}
