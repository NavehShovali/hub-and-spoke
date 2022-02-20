resource "azurerm_public_ip" "public_ip" {
  allocation_method   = "Static"
  location            = var.location
  name                = "${var.name}-public-ip"
  resource_group_name = var.resource_group_name
  sku                 = "Standard"
}

resource "azurerm_firewall" "firewall" {
  location            = var.location
  name                = var.name
  resource_group_name = var.resource_group_name
  firewall_policy_id  = var.firewall_policy_id

  ip_configuration {
    name                 = "${var.name}-ip-configuration"
    public_ip_address_id = azurerm_public_ip.public_ip.id
    subnet_id            = var.subnet_id
  }

  depends_on = [azurerm_public_ip.public_ip]
}
