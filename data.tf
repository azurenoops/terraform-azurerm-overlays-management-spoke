# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

# remove file if not needed
data "azurerm_client_config" "current" {}

data "azurerm_resource_group" "netwatch" {
  depends_on = [azurerm_virtual_network.spoke_vnet]
  count      = var.is_spoke_deployed_to_same_hub_subscription ? 1 : 0
  name       = "NetworkWatcherRG"
}