data "azurerm_virtual_network" "hub-vnet" {
  name                = "anoa-usgva-hub-core-dev-vnet"
  resource_group_name = "anoa-usgva-hub-core-dev-rg"
}

data "azurerm_storage_account" "hub-st" {
  name                = "anoausgva8173b4d424devst"
  resource_group_name = "anoa-usgva-hub-core-dev-rg"
}

data "azurerm_firewall" "hub-fw" {
  name                = "anoa-usgva-hub-core-dev-fw"
  resource_group_name = "anoa-usgva-hub-core-dev-rg"
}

data "azurerm_log_analytics_workspace" "hub-logws" {
  name                = "anoa-usgva-ops-mgt-logging-dev-log"
  resource_group_name = "anoa-usgva-ops-mgt-logging-dev-rg"
}