resource "azurerm_subnet" "app-tier-subnet" {
  name                 = "app-subnet"
  resource_group_name  = azurerm_resource_group.networking_terraform.name
  virtual_network_name = azurerm_virtual_network.my-virtual-network.name
  address_prefixes     = ["10.0.11.0/24"]
}

resource "azurerm_network_security_group" "app-tier-nsg" {
  resource_group_name = azurerm_resource_group.networking_terraform.name
  location            = azurerm_resource_group.networking_terraform.location
  name                = "${azurerm_subnet.app-tier-subnet.name}-nsg"

}
locals {
  app_inbound_port_map = {
    "100" : "80",
    "110" : "443",
    "120" : "8080"
    "130" : "22"
  }
}
resource "azurerm_network_security_rule" "app-inbound-rule" {
  for_each                    = local.app_inbound_port_map
  resource_group_name         = azurerm_resource_group.networking_terraform.name
  network_security_group_name = azurerm_network_security_group.app-tier-nsg.name
  name                        = "${azurerm_subnet.app-tier-subnet.name}-inbound-${each.value}"
  priority                    = each.key
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  destination_port_range      = each.value
}
resource "azurerm_subnet_network_security_group_association" "app_subnet_nsg_associate" {
  depends_on                = [azurerm_network_security_rule.app-inbound-rule]
  subnet_id                 = azurerm_subnet.app-tier-subnet.id
  network_security_group_id = azurerm_network_security_group.app-tier-nsg.id

}