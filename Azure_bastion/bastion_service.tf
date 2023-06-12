#Pre-requisite 1: bastion sevice subnet
resource "azurerm_subnet" "bastion_service_subnet" {
  name                 = var.bastion_service_subnet_name
  address_prefixes     = var.bastion_service_address_prrefixe
  resource_group_name  = azurerm_resource_group.bastion_terraform.name
  virtual_network_name = azurerm_virtual_network.my-virtual-network.name

}
#pre-rquisite 2: public ip address
resource "azurerm_public_ip" "bastion_service_public_ip" {
  name                = "basion-service-public-ip"
  resource_group_name = azurerm_resource_group.bastion_terraform.name
  location            = azurerm_resource_group.bastion_terraform.location
  allocation_method   = "Static"
  sku                 = "Standard"
}

#Resource bastion host
resource "azurerm_bastion_host" "bastion_host" {
  name                = "bastion-service"
  location            = azurerm_resource_group.bastion_terraform.location
  resource_group_name = azurerm_resource_group.bastion_terraform.name
  ip_configuration {
    name                 = "configuration"
    subnet_id            = azurerm_subnet.bastion_service_subnet.id
    public_ip_address_id = azurerm_public_ip.bastion_service_public_ip.id
  }
}