resource "azurerm_resource_group" "rg_terraform" {
  name     = "load-balancer-terraform"
  location = "Brazil South"

}
resource "azurerm_virtual_network" "my-virtual-network" {
  name                = "network-terraform"
  location            = azurerm_resource_group.rg_terraform.location
  resource_group_name = azurerm_resource_group.rg_terraform.name
  address_space       = ["10.0.0.0/16"]

}
