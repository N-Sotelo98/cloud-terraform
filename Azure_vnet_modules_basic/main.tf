resource "azurerm_resource_group" "resource_group" {
  name     = var.resource_group_name
  location = "West Europe"
}

module "VPC" {
  source                  = "./VPC"
  resource_group_name     = azurerm_resource_group.resource_group.name
  resource_group_location = azurerm_resource_group.resource_group.location
  hub_vnet_name           = "hub_vnet_test"
  hub_vnet_address_space  = "10.1.0.0/16"
  subnets                 = { "gateway-subnet" = "10.1.1.0/24", "application-gateway" = "10.1.2.0/24", "bastion-subnet" = "10.1.3.0/24", "firewall-subnet" = "10.1.4.0/24" }
}