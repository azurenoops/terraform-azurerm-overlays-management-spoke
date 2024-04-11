data "azurerm_client_config" "current" {}

data "azurerm_virtual_network" "hub-vnet" {
  name                = "an1-usgva-hub-dev-vnet"
  resource_group_name = "an1-usgva-hub-dev-rg"
}

data "azurerm_firewall" "hub-fw" {
  name                = "an1-usgva-hub-dev-fw"
  resource_group_name = "an1-usgva-hub-dev-rg"
}

data "azurerm_log_analytics_workspace" "hub-logws" {
  name                = "laws-eastus-an1"
  resource_group_name = "laws-rg-eastus-an1"
}

data "azurerm_resource_group" "dns" {
  name       = "an1-eus-dns-dev-rg"
}
