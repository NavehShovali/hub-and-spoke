resource "azurerm_route_table" "route_table" {
  location            = var.location
  name                = var.name
  resource_group_name = var.resource_group_name

  dynamic "route" {
    for_each = {for route in var.routes : route.name => route}
    content {
      address_prefix         = route.value.address_prefix
      name                   = route.key
      next_hop_type          = "VirtualAppliance"
      next_hop_in_ip_address = var.firewall_internal_ip
    }
  }
}

resource "azurerm_subnet_route_table_association" "route_table" {
  for_each       = toset(var.associated_subnets_ids)
  route_table_id = azurerm_route_table.route_table.id
  subnet_id      = each.key
}
