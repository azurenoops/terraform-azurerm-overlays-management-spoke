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

