# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

# This is used to create an alias for the hub network to allow peering between the hub and spoke.

#-----------------------------------------------
# Peering between Hub and Spoke Virtual Network
#-----------------------------------------------
resource "azurerm_virtual_network_peering" "spoke_to_hub" {
  name                         = lower("peering-${var.workload_name}-spoke-to-${data.azurerm_virtual_network.hub_vnet.name}")
  resource_group_name          = local.resource_group_name
  virtual_network_name         = azurerm_virtual_network.spoke_vnet.name
  remote_virtual_network_id    = data.azurerm_virtual_network.hub_vnet.id
  allow_virtual_network_access = var.allow_source_virtual_spoke_network_access
  allow_forwarded_traffic      = var.allow_source_forwarded_spoke_traffic
  allow_gateway_transit        = var.allow_source_gateway_spoke_transit
  use_remote_gateways          = var.use_source_remote_spoke_gateway
}

resource "azurerm_virtual_network_peering" "hub_to_spoke" {
  provider                     = azurerm.hub_network
  name                         = lower("peering-${data.azurerm_virtual_network.hub_vnet.name}-to-${var.workload_name}-spoke")
  resource_group_name          = data.azurerm_virtual_network.hub_vnet.resource_group_name
  virtual_network_name         = data.azurerm_virtual_network.hub_vnet.name
  remote_virtual_network_id    = azurerm_virtual_network.spoke_vnet.id
  allow_gateway_transit        = var.allow_dest_gateway_hub_transit
  allow_forwarded_traffic      = var.allow_dest_forwarded_hub_traffic
  allow_virtual_network_access = var.allow_dest_virtual_hub_network_access
  use_remote_gateways          = var.use_dest_remote_hub_gateway
}
