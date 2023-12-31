provider "azurerm" {
  tenant_id       = var.tenant_id
  subscription_id = var.subscription_id
  client_id       = var.client_id
  client_secret   = var.client_secret
  features {}
}
terraform {
  backend "azurerm" {
    storage_account_name = "tfstate3167412051"
    container_name       = "tfstate"
    key                  = "test.terraform.tfstate"
    access_key           = "BFjrUPtGMk1DZZqwunBfWIBvHcMVH1Z617yMvqj/ObB+jXhouiS3XzFXfMncItymJ9FcWrS7oT2i+AStYf7vKA=="
  }
}
data "azurerm_resource_group" "test" {
  name = "Azuredevops"
}
module "network" {
  source               = "../../modules/network"
  address_space        = var.address_space
  location             = var.location
  virtual_network_name = var.virtual_network_name
  application_type     = var.application_type
  resource_type        = "NET"
  resource_group       = data.azurerm_resource_group.test.name
  address_prefix_test  = var.address_prefix_test
}

module "nsg-test" {
  source              = "../../modules/networksecuritygroup"
  location            = var.location
  application_type    = var.application_type
  resource_type       = "NSG"
  resource_group      = data.azurerm_resource_group.test.name
  subnet_id           = module.network.subnet_id_test
  address_prefix_test = var.address_prefix_test
}
module "appservice" {
  source           = "../../modules/appservice"
  location         = var.location
  application_type = var.application_type
  resource_type    = "AppService"
  resource_group   = data.azurerm_resource_group.test.name
}
module "publicip" {
  source           = "../../modules/publicip"
  location         = var.location
  application_type = var.application_type
  resource_type    = "publicip"
  resource_group   = data.azurerm_resource_group.test.name
}

