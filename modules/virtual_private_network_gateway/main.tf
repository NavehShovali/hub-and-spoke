resource "azurerm_public_ip" "gateway_ips" {
  for_each = var.active_active ? toset(["-1", "-2"]) : toset([""])

  name                = "${var.name}-public-ip${each.value}"
  location            = var.location
  resource_group_name = var.resource_group_name

  allocation_method = var.public_ip_allocation_method
}

resource "azurerm_virtual_network_gateway" "gateway" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name

  generation                 = var.generation
  sku                        = var.sku
  type                       = var.type
  vpn_type                   = var.vpn_type
  active_active              = var.active_active
  private_ip_address_enabled = false

  dynamic "ip_configuration" {
    for_each = azurerm_public_ip.gateway_ips

    content {
      public_ip_address_id = ip_configuration.value.id
      subnet_id            = var.subnet_id
    }
  }

  vpn_client_configuration {
    address_space        = var.address_prefixes
    vpn_client_protocols = var.vpn_client_protocols
    vpn_auth_types       = var.vpn_auth_types
    aad_audience         = var.azure_active_directory_authentication.audience
    aad_issuer           = var.azure_active_directory_authentication.issuer
    aad_tenant           = var.azure_active_directory_authentication.tenant
  }
}
