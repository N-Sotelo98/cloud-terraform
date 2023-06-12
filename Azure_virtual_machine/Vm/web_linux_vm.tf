resource "azurerm_network_security_group" "web_vmnic_nsg" {
  name                = "${azurerm_network_interface.web-linux-nic.name}-nsg"
  location            = azurerm_resource_group.virtual-machine-rg.location
  resource_group_name = azurerm_resource_group.virtual-machine-rg.name


}

locals {
  web_vmnic_inbound_map = {
    "100" : "80",
    "110" : "443",
    "120" : "22"
  }
}
resource "azurerm_network_security_rule" "linux_vmnic_nsg_inbound_rules" {
  for_each                    = local.web_vmnic_inbound_map
  resource_group_name         = azurerm_resource_group.virtual-machine-rg.name
  network_security_group_name = azurerm_network_security_group.web_vmnic_nsg.name
  name                        = "Rule-inbound-${each.value}"
  priority                    = each.key
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  destination_port_range      = each.value

}
resource "azurerm_network_interface_security_group_association" "web_vmnic_nsg_associate" {
  depends_on                = [azurerm_network_security_rule.linux_vmnic_nsg_inbound_rules]
  network_interface_id      = azurerm_network_interface.web-linux-nic.id
  network_security_group_id = azurerm_network_security_group.web_vmnic_nsg.id
}


locals {
  webvmlocal = <<CUSTOM_DATA
#!/bin/sh
#!/bin/sh
#sudo yum update -y
sudo yum install -y httpd
sudo systemctl enable httpd
sudo systemctl start httpd  
sudo systemctl stop firewalld
sudo systemctl disable firewalld
sudo chmod -R 777 /var/www/html 
sudo echo "Welcome to stacksimplify - WebVM App1 - VM Hostname: $(hostname)" > /var/www/html/index.html
sudo mkdir /var/www/html/app1
sudo echo "Welcome to stacksimplify - WebVM App1 - VM Hostname: $(hostname)" > /var/www/html/app1/hostname.html
sudo echo "Welcome to stacksimplify - WebVM App1 - App Status Page" > /var/www/html/app1/status.html
sudo echo '<!DOCTYPE html> <html> <body style="background-color:rgb(250, 210, 210);"> <h1>Welcome to Stack Simplify - WebVM APP-1 </h1> <p>Terraform Demo</p> <p>Application Version: V1</p> </body></html>' | sudo tee /var/www/html/app1/index.html
sudo curl -H "Metadata:true" --noproxy "*" "http://169.254.169.254/metadata/instance?api-version=2020-09-01" -o /var/www/html/app1/metadata.html
CUSTOM_DATA  
}
resource "azurerm_linux_virtual_machine" "weblinuxvm" {
  resource_group_name   = azurerm_resource_group.virtual-machine-rg.name
  location              = azurerm_resource_group.virtual-machine-rg.location
  name                  = "weblinux-vm"
  size                  = "Standard_DS1_v2"
  admin_username        = "azureuser"
  network_interface_ids = [azurerm_network_interface.web-linux-nic.id]
  admin_ssh_key {
    username   = "azureuser"
    public_key = file("../SSH keys/terraform-azure.pub")
  }
  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
  source_image_reference {
    publisher = "RedHat"
    offer     = "RHEL"
    sku       = "83-gen2"
    version   = "latest"
  }
  custom_data = base64encode(local.webvmlocal)

}