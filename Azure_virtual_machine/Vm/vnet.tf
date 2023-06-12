resource "azurerm_virtual_network" "my-virtual-network" {
  name                = "network-terraform"
  location            = azurerm_resource_group.virtual-machine-rg.location
  resource_group_name = azurerm_resource_group.virtual-machine-rg.name
  address_space       = ["10.0.0.0/16"]

}
