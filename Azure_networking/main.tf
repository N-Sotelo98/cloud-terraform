resource "azurerm_resource_group" "networking_terraform" {
  name     = "network-project-terraform"
  location = "Brazil South"

}
resource "azurerm_virtual_network" "my-virtual-network" {
  name                = "network-terraform"
  location            = azurerm_resource_group.networking_terraform.location
  resource_group_name = azurerm_resource_group.networking_terraform.name
  address_space       = ["10.0.0.0/16"]

}
