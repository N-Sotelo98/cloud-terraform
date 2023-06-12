resource "azurerm_resource_group" "azure_storage_terraform" {
    name="terrafom-storage"
    location = "Brazil South"
  
}
resource "azurerm_storage_account" "terraform_storage" {
name="storagetfns"
resource_group_name = azurerm_resource_group.azure_storage_terraform.name
location=  azurerm_resource_group.azure_storage_terraform.location
account_tier = "Standard"
account_replication_type = "GRS"
}