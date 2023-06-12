#Resource 1:public ip address
resource "azurerm_public_ip" "lb_public_ip" {
  name                = "lb-public-ip"
  resource_group_name = azurerm_resource_group.rg_terraform.name
  location            = azurerm_resource_group.rg_terraform.location
  allocation_method   = "Static"
  sku                 = "Standard"


}
#Resource 2: azure standard load balancer
resource "azurerm_lb" "lb_standard" {
  name                = "web_load_balancer_standard"
  location            = azurerm_resource_group.rg_terraform.location
  resource_group_name = azurerm_resource_group.rg_terraform.name
  sku                 = "Standard"
  frontend_ip_configuration {
    name                 = "web-lb-public-1"
    public_ip_address_id = azurerm_public_ip.lb_public_ip.id

  }

}
#Resource 3: Backend pool
resource "azurerm_lb_backend_address_pool" "web_lb_backend_address_pool" {
  name            = "backend"
  loadbalancer_id = azurerm_lb.lb_standard.id

}
#Resource 4: Probe
resource "azurerm_lb_probe" "web_lb_probe" {
  name            = "lb_probe"
  protocol        = "Tcp"
  port            = 80
  loadbalancer_id = azurerm_lb.lb_standard.id


}
#Resource 5 Load balancer rule
resource "azurerm_lb_rule" "lb_rule_app" {
  name                           = "web-app1-rule"
  protocol                       = "Tcp"
  frontend_port                  = 80
  backend_port                   = 80
  frontend_ip_configuration_name = azurerm_lb.lb_standard.frontend_ip_configuration[0].name
  backend_address_pool_ids       = [azurerm_lb_backend_address_pool.web_lb_backend_address_pool.id]
  probe_id                       = azurerm_lb_probe.web_lb_probe.id
  loadbalancer_id                = azurerm_lb.lb_standard.id

}
#Resource 6: associate network interface connects between pool and vms
resource "azurerm_network_interface_backend_address_pool_association" "web_nic_lb_pool_associate" {
  network_interface_id    = azurerm_network_interface.web-linux-nic.id
  ip_configuration_name   = azurerm_network_interface.web-linux-nic.ip_configuration[0].name
  backend_address_pool_id = azurerm_lb_backend_address_pool.web_lb_backend_address_pool.id
}