output "bastion_host_linux_ip" {
  value = azurerm_linux_virtual_machine.bastion_linux_vm.public_ip_address
}