resource "azurerm_lb_nat_rule" "lb_nat_ibound_ssh" {
  name                           = "ssh-nat-inbound-rule"
  protocol                       = "Tcp"
  frontend_port                  = 1023
  backend_port                   = 22
  frontend_ip_configuration_name = azurerm_lb.lb_standard.frontend_ip_configuration[0].name
  resource_group_name            = azurerm_resource_group.rg_terraform.name
  loadbalancer_id                = azurerm_lb.lb_standard.id
}

resource "azurerm_network_interface_nat_rule_association" "web_nic_nat_asscoiat" {
  network_interface_id  = azurerm_network_interface.web-linux-nic.id
  ip_configuration_name = azurerm_network_interface.web-linux-nic.ip_configuration[0].name
  nat_rule_id           = azurerm_lb_nat_rule.lb_nat_ibound_ssh.id


}