# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

# This is used to create an alias for the hub network to allow peering between the hub and spoke.

# Split on the "/" character on var.hub_virtual_network_id and return the 8th element. This is the virtual_network_name.
# Split on the "/" character on var.hub_virtual_network_id and return the 4th element. This is the resource group name.
# Split on the "/" character on var.hub_virtual_network_id and return the 2th element. This is the subscription id.

#-------------------------------------
# Azure Provider Alias for Peering
#-------------------------------------
provider "azurerm" {
  alias           = "hub_network"
  subscription_id = element(split("/", var.hub_virtual_network_id), 2)
  features {}
}

#-----------------------------------------------
# Peering between Hub and Spoke Virtual Network
#-----------------------------------------------
resource "azurerm_virtual_network_peering" "spoke_to_hub" {
  name                         = lower("peering-to-hub-${element(split("/", var.hub_virtual_network_id), 8)}")
  resource_group_name          = local.resource_group_name
  virtual_network_name         = azurerm_virtual_network.spoke_vnet.name
  remote_virtual_network_id    = var.hub_virtual_network_id
  allow_virtual_network_access = var.allow_source_virtual_spoke_network_access
  allow_forwarded_traffic      = var.allow_source_forwarded_spoke_traffic
  allow_gateway_transit        = var.allow_source_gateway_spoke_transit
  use_remote_gateways          = var.use_source_remote_spoke_gateway
}

resource "azurerm_virtual_network_peering" "hub_to_spoke" {
  provider                     = azurerm.hub_network
  name                         = lower("peering-${element(split("/", var.hub_virtual_network_id), 8)}-to-${var.workload_name}-spoke")
  resource_group_name          = element(split("/", var.hub_virtual_network_id), 4)
  virtual_network_name         = element(split("/", var.hub_virtual_network_id), 8)
  remote_virtual_network_id    = azurerm_virtual_network.spoke_vnet.id
  allow_gateway_transit        = var.allow_dest_gateway_hub_transit
  allow_forwarded_traffic      = var.allow_dest_forwarded_hub_traffic
  allow_virtual_network_access = var.allow_dest_virtual_hub_network_access
  use_remote_gateways          = var.use_dest_remote_hub_gateway
}
