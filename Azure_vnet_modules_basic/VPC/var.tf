variable "resource_group_name" {
  description = "Name of resource group"
  default     = "terraform-rg"
  type        = string

}
variable "resource_group_location" {
  description = "Name of resource group"
  type        = string

}
variable "hub_vnet_name" {
  type    = string
  default = "hub_v"
}
variable "hub_vnet_address_space" {
  type    = string
  default = "10.0.0.0/16"

}
variable "subnets" {
    default = {
        "subnet-1":"10.0.0.1/24",
        "subnet-2":"10.0.0.2/24",
        "subnet-3":"10.0.0.3/24",
        "subnet-4":"10.0.0.4/24"
    }
}