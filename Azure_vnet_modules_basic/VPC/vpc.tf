resource "azurerm_virtual_network" "hub_vnet" {
    resource_group_name = var.resource_group_name
    location=var.resource_group_location
    name=var.hub_vnet_name
    address_space = [var.hub_vnet_address_space]
    dynamic "subnet" {
        for_each = var.subnets
        iterator = item
        content {
          name=item.key
          address_prefix = item.value
        }
      
    }
    
}