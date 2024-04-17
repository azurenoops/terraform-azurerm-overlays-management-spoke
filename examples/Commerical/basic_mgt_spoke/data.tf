data "azurerm_client_config" "current" {}

data "azurerm_virtual_network" "hub-vnet" {
  provider = azurerm.hub
  name                = "an1-eus-hub-dev-vnet"
  resource_group_name = "an1-eus-hub-dev-rg"
}

data "azurerm_firewall" "hub-fw" {
  provider = azurerm.hub
  name                = "an1-eus-hub-dev-fw"
  resource_group_name = "an1-eus-hub-dev-rg"
}

data "azurerm_log_analytics_workspace" "hub-logws" {
  provider = azurerm.hub
  name                = "laws-eastus-an1"
  resource_group_name = "laws-rg-eastus-an1"
}

data "azurerm_resource_group" "dns" {
  provider = azurerm.hub
  name       = "an1-eus-dns-dev-rg"
}
