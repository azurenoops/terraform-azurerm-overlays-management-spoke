# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

/*
SUMMARY: Module to deploy a route table in the Management Spoke Network based on the Azure Mission Landing Zone conceptual architecture
DESCRIPTION: The following components will be options in this deployment
              * Route Table
                * Route Table Association
                * Route
AUTHOR/S: jrspinella
*/

resource "azurerm_route_table" "routetable" {
  name                          = local.spoke_rt_name
  resource_group_name           = local.resource_group_name
  location                      = local.location
  disable_bgp_route_propagation = var.disable_bgp_route_propagation
  tags                          = merge({ "ResourceName" = "route-network-outbound" }, local.default_tags, var.add_tags, )
}

resource "azurerm_subnet_route_table_association" "rtassoc" {
  for_each       = var.spoke_subnets
  subnet_id      = azurerm_subnet.default_snet[each.key].id
  route_table_id = azurerm_route_table.routetable.id
}

resource "azurerm_route" "force_internet_tunneling" {
  name                   = lower("route-to-firewall-${local.spoke_vnet_name}-${local.location}")
  resource_group_name    = local.resource_group_name
  route_table_name       = azurerm_route_table.routetable.name
  address_prefix         = "0.0.0.0/0"
  next_hop_type          = "VirtualAppliance"
  next_hop_in_ip_address = var.existing_hub_firewall_private_ip_address

  count = var.enable_forced_tunneling_on_route_table ? 1 : 0
}

resource "azurerm_route" "route" {
  for_each               = var.route_table_routes
  name                   = lower("route-to-firewall-${each.value.name}-${local.location}")
  resource_group_name    = local.resource_group_name
  route_table_name       = azurerm_route_table.routetable.name
  address_prefix         = each.value.address_prefix
  next_hop_type          = each.value.next_hop_type
  next_hop_in_ip_address = each.value.next_hop_in_ip_address
}
