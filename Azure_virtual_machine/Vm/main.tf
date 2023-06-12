resource "azurerm_resource_group" "virtual-machine-rg" {
  name     = "network-project-terraform"
  location = "Brazil South"

}
resource "azurerm_public_ip" "web_linux_vm" {
  name                = "web-public-ip"
  resource_group_name = azurerm_resource_group.virtual-machine-rg.name
  location            = azurerm_resource_group.virtual-machine-rg.location
  allocation_method   = "Static"

}
resource "azurerm_network_interface" "web-linux-nic" {
  name                = "${azurerm_resource_group.virtual-machine-rg.name}-linux-nic"
  resource_group_name = azurerm_resource_group.virtual-machine-rg.name
  location            = azurerm_resource_group.virtual-machine-rg.location
  ip_configuration {
    name                          = "web-linux-vm-1"
    subnet_id                     = azurerm_subnet.web-tier-subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.web_linux_vm.id
  }
}