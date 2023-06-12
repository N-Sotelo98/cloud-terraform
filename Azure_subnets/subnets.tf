resource "azurerm_resource_group" "example" {
  name     = "example-resources"
  location = "West Europe"
}
resource "azurerm_virtual_network" "network" {
  name                = "terraform_vnet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
}
resource "azurerm_subnet" "subnet_example" {
  for_each             = var.subnets_config
  name                 = "${each.key}"
  resource_group_name  = azurerm_resource_group.example.name
  virtual_network_name = azurerm_virtual_network.network.name
  address_prefixes     = [each.value]


}
variable "subnets_config" {
    type=map(string)
    default = {
        "subnetf"="10.0.1.0/24"
        "subnetf2"="10.0.2.0/24"
        "subnetf3"="10.0.3.0/24"
    }
  
}