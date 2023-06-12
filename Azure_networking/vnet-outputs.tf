output "vnet-name" {
  value = azurerm_virtual_network.my-virtual-network.name

}
output "vnet_id" {
  value = azurerm_virtual_network.my-virtual-network.id
}
output "web_subnet_name" {
  value = azurerm_subnet.web-tier-subnet.name
}
output "web_subnet_id" {
  value = azurerm_subnet.web-tier-subnet.id
}
output "nsg_web_subnet_name" {
  value = azurerm_network_security_group.web-tier-nsg.name

}
output "nsg_web_subnet_id" {
  value = azurerm_network_security_group.web-tier-nsg.id

}