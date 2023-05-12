#-----------------------------------------------
# Peering between Hub and Spoke Virtual Network
#-----------------------------------------------
resource "azurerm_virtual_network_peering" "spoke_to_hub" {
  name                         = lower("peering-to-hub-${element(split("/", var.hub_virtual_network_id), 8)}")
  resource_group_name          = local.resource_group_name
  virtual_network_name         = azurerm_virtual_network.spoke_vnet.name
  remote_virtual_network_id    = var.hub_virtual_network_id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  allow_gateway_transit        = false
  use_remote_gateways          = var.use_source_remote_spoke_gateway
}

resource "azurerm_virtual_network_peering" "hub_to_spoke" {
  provider                     = azurerm.hub_network
  name                         = lower("peering-${element(split("/", var.hub_virtual_network_id), 8)}-to-spoke")
  resource_group_name          = element(split("/", var.hub_virtual_network_id), 4)
  virtual_network_name         = element(split("/", var.hub_virtual_network_id), 8)
  remote_virtual_network_id    = azurerm_virtual_network.spoke_vnet.id
  allow_gateway_transit        = false
  allow_forwarded_traffic      = true
  allow_virtual_network_access = true
  use_remote_gateways          = var.use_dest_remote_hub_gateway
}
