resource "azurerm_subnet" "bastion-tier-subnet" {
  name                 = "bastion-subnet"
  resource_group_name  = azurerm_resource_group.networking_terraform.name
  virtual_network_name = azurerm_virtual_network.my-virtual-network.name
  address_prefixes     = ["10.0.100.0/24"]
}

resource "azurerm_network_security_group" "bastion-tier-nsg" {
  resource_group_name = azurerm_resource_group.networking_terraform.name
  location            = azurerm_resource_group.networking_terraform.location
  name                = "${azurerm_subnet.bastion-tier-subnet.name}-nsg"

}
locals {
  bastion_inbound_port_map = {
    "100" : "22",
    "110":"3389"
    
  }
}
resource "azurerm_network_security_rule" "bastion-inbound-rule" {
  for_each                    = local.bastion_inbound_port_map
  resource_group_name         = azurerm_resource_group.networking_terraform.name
  network_security_group_name = azurerm_network_security_group.bastion-tier-nsg.name
  name                        = "${azurerm_subnet.bastion-tier-subnet.name}-inbound-${each.value}"
  priority                    = each.key
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  destination_port_range      = each.value
}
resource "azurerm_subnet_network_security_group_association" "bastion_subnet_nsg_associate" {
  depends_on                = [azurerm_network_security_rule.bastion-inbound-rule]
  subnet_id                 = azurerm_subnet.bastion-tier-subnet.id
  network_security_group_id = azurerm_network_security_group.bastion-tier-nsg.id

}