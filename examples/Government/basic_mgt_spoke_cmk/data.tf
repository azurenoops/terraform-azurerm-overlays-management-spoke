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
  name                = "laws-usgva-an1"
  resource_group_name = "laws-rg-usgva-an1"
}


data "azurerm_private_dns_zone" "blob" {
  name                = "privatelink.blob.core.usgovcloudapi.net"
  resource_group_name = "an1-eus-dns-dev-rg"
  
}

data "azurem_key_vault" "kv" {
  name                = "an1-usgva-hub-dev-kv"
  resource_group_name = "an1-usgva-hub-dev-rg"
}
