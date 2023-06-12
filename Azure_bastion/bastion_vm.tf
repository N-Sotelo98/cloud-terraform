#Pre-requisite 1 public ip address
resource "azurerm_public_ip" "bastion_host_ip" {
  name                = "basion-host-public-ip"
  resource_group_name = azurerm_resource_group.bastion_terraform.name
  location            = azurerm_resource_group.bastion_terraform.location
  allocation_method   = "Static"
  sku                 = "Standard"
}
#Pre-requisite 2 network interface
resource "azurerm_network_interface" "bastion_host_nic" {
  name                = "bastion-host-nic"
  resource_group_name = azurerm_resource_group.bastion_terraform.name
  location            = azurerm_resource_group.bastion_terraform.location
  ip_configuration {
    name                          = "bastion-host-ip-1"
    subnet_id                     = azurerm_subnet.bastion-tier-subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.bastion_host_ip.id
  }

}
#Bastion linux VM resource
resource "azurerm_linux_virtual_machine" "bastion_linux_vm" {
  name                  = "linux-bastion-vm-host"
  resource_group_name   = azurerm_resource_group.bastion_terraform.name
  location              = azurerm_resource_group.bastion_terraform.location
  size                  = "Standard_DS1_v2"
  admin_username        = "azureuser"
  network_interface_ids = [azurerm_network_interface.bastion_host_nic.id]
  admin_ssh_key {
    username   = "azureuser"
    public_key = file("./ssh/terraform-azure.pub")

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

}
#Use null resource to provision-configure the bastion vm host
resource "null_resource" "name" {
  depends_on = [azurerm_linux_virtual_machine.bastion_linux_vm]
  #Establish connection to the machine
  connection {
    type        = "ssh"
    host        = azurerm_linux_virtual_machine.bastion_linux_vm.public_ip_address
    user        = azurerm_linux_virtual_machine.bastion_linux_vm.admin_username
    private_key = file("${path.module}/ssh/terraform-azure.pem")

  }
  #move file to vm
  provisioner "file" {
    source      = "./ssh/terraform-azure.pem"
    destination = "/tmp/terraform-azure.pem"

  }
  #execute command on vm
  provisioner "remote-exec" {
    inline = [
      "sudo chmod 400 /tmp/terraform-azure.pem"
    ]

  }

}