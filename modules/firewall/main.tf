resource "azurerm_public_ip" "public_ip" {
  name                = "${var.name}-public-ip"
  location            = var.location
  resource_group_name = var.resource_group_name

  allocation_method = "Static"
  sku               = var.public_ip_sku
}

module "hub_firewall_policy" {
  source = "../firewall_policy"

  name                = "${var.name}-policy"
  location            = var.location
  resource_group_name = var.resource_group_name

  policy_rule_collection_groups = var.policy_rule_collection_groups
}

resource "azurerm_firewall" "firewall" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name

  firewall_policy_id = module.hub_firewall_policy.id
  private_ip_ranges  = var.private_ip_ranges

  ip_configuration {
    name                 = "${var.name}-ip-configuration"
    public_ip_address_id = azurerm_public_ip.public_ip.id
    subnet_id            = var.subnet_id
  }

  depends_on = [azurerm_public_ip.public_ip, module.hub_firewall_policy]
}
