
data "azurerm_virtual_network" "hub-vnet" {
  name                = "anoa-eus-hub-core-dev-vnet"
  resource_group_name = "anoa-eus-hub-core-dev-rg"
}

data "azurerm_storage_account" "hub-st" {
  name                = "anoaeusf6a6b3aa32devst"
  resource_group_name = "anoa-eus-hub-core-dev-rg"
}

data "azurerm_log_analytics_workspace" "hub-logws" {
  name                = "anoa-eus-ops-mgt-logging-dev-log"
  resource_group_name = "anoa-eus-ops-mgt-logging-dev-rg"
}