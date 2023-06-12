resource "azurerm_subnet" "web-tier-subnet" {
  name                 = "web-subnet"
  resource_group_name  = azurerm_resource_group.bastion_terraform.name
  virtual_network_name = azurerm_virtual_network.my-virtual-network.name
  address_prefixes     = ["10.0.1.0/24"]
}
resource "azurerm_network_security_group" "web-tier-nsg" {
  resource_group_name = azurerm_resource_group.bastion_terraform.name
  location            = azurerm_resource_group.bastion_terraform.location
  name                = "${azurerm_subnet.web-tier-subnet.name}-nsg"

}
locals {
  web_inbound_port_map = {
    "100" : "80",
    "110" : "443",
    "120" : "22"
  }
}
resource "azurerm_network_security_rule" "web-inbound-rule" {
  for_each                    = local.web_inbound_port_map
  resource_group_name         = azurerm_resource_group.bastion_terraform.name
  network_security_group_name = azurerm_network_security_group.web-tier-nsg.name
  name                        = "${azurerm_subnet.web-tier-subnet.name}-inbound-${each.value}"
  priority                    = each.key
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  destination_port_range      = each.value
}
resource "azurerm_subnet_network_security_group_association" "web_subnet_nsg_associate" {
  depends_on                = [azurerm_network_security_rule.web-inbound-rule]
  subnet_id                 = azurerm_subnet.web-tier-subnet.id
  network_security_group_id = azurerm_network_security_group.web-tier-nsg.id

}