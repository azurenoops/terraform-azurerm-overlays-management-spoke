data "azurerm_client_config" "current" {}

data "azurerm_virtual_network" "hub-vnet" {
  name                = "an16-usgva-hub-dev-vnet"
  resource_group_name = "an16-usgva-hub-dev-rg"
}

data "azurerm_firewall" "hub-fw" {
  name                = "an16-usgva-hub-dev-fw"
  resource_group_name = "an16-usgva-hub-dev-rg"
}

data "azurerm_log_analytics_workspace" "hub-logws" {
  name                = "laws-usgovvirginia-an16"
  resource_group_name = "laws-rg-usgovvirginia-an16"
}


data "azurerm_private_dns_zone" "blob" {
  name                = "privatelink.blob.core.usgovcloudapi.net"
  resource_group_name = "an16-usgva-dns-dev-rg"
  
}

data "azurerm_key_vault" "kv" {
  name                = "kv-usgovvirginia-an16"
  resource_group_name = "laws-rg-usgovvirginia-an16"
}
