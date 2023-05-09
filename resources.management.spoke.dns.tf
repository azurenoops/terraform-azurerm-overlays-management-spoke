# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

#---------------------------------------------
# Linking Spoke Vnet to Hub Private DNS Zone
#---------------------------------------------
resource "azurerm_private_dns_zone_virtual_network_link" "dzvlink" {
  provider              = azurerm.hub_network
  for_each              = toset(var.private_dns_zones_to_link_to_hub)
  name                  = lower("${each.key}-link-to-hub")
  resource_group_name   = element(split("/", var.hub_virtual_network_id), 4)
  virtual_network_id    = azurerm_virtual_network.spoke_vnet.id
  private_dns_zone_name = each.key
  registration_enabled  = true
  tags                  = merge({ "ResourceName" = format("%s", lower("${each.key}-link-to-hub")) }, local.default_tags, var.add_tags, )
}
