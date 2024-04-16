# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

# remove file if not needed
data "azurerm_client_config" "current" {}

data "azurerm_resource_group" "netwatch" {
  depends_on = [module.spoke_vnet]
  name       = "NetworkWatcherRG"
}

data "azurerm_network_watcher" "nwatcher" {
  depends_on          = [module.spoke_vnet]
  name                = "NetworkWatcher_${local.location}"
  resource_group_name = data.azurerm_resource_group.netwatch.name
}

data "azurerm_firewall" "hub-fw" {
  depends_on          = [module.spoke_vnet]
  provider            = azurerm.hub_network
  name                = var.existing_hub_firewall_name
  resource_group_name = var.existing_hub_resource_group_name
}

data "azurerm_log_analytics_workspace" "log_analytics" {
  depends_on          = [module.spoke_vnet]
  provider            = azurerm.hub_network
  name                = var.existing_log_analytics_workspace_name
  resource_group_name = var.existing_log_analytics_workspace_resource_name
}

data "azurerm_private_dns_zone" "blob" {
  depends_on          = [module.spoke_st]
  provider            = azurerm.hub_network
  name                = "privatelink.blob.core.windows.net"
  resource_group_name = var.private_dns_zone_hub_resource_group_name
}
