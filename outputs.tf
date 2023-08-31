# Copyright (c) Microsoft Corporation.spoke_vnet
# Licensed under the MIT License.

###############
# Outputs    ##
###############

output "resource_group_name" {
  description = "The name of the resource group in which resources are created"
  value       = element(coalescelist(data.azurerm_resource_group.rgrp.*.name, module.mod_scaffold_rg.*.resource_group_name, [""]), 0)
}

output "resource_group_id" {
  description = "The id of the resource group in which resources are created"
  value       = element(coalescelist(data.azurerm_resource_group.rgrp.*.id, module.mod_scaffold_rg.*.resource_group_id, [""]), 0)
}

output "resource_group_location" {
  description = "The location of the resource group in which resources are created"
  value       = element(coalescelist(data.azurerm_resource_group.rgrp.*.location, module.mod_scaffold_rg.*.resource_group_location, [""]), 0)
}

# Vnet and Subnets
output "virtual_network_name" {
  description = "The name of the virtual network"
  value       = element(concat(azurerm_virtual_network.spoke_vnet.*.name, [""]), 0)
}

output "virtual_network_id" {
  description = "The id of the virtual network"
  value       = element(concat(azurerm_virtual_network.spoke_vnet.*.id, [""]), 0)
}

output "virtual_network_address_space" {
  description = "List of address spaces that are used the virtual network."
  value       = element(coalescelist(azurerm_virtual_network.spoke_vnet.*.address_space, [""]), 0)
}

output "subnet_ids" {
  description = "Map of IDs of subnets"
  value = { for key, name in zipmap(
    sort(keys(var.spoke_subnets)),
    sort(values(azurerm_subnet.default_snet)[*]["id"])) :
  key => { key = key, name = name } }
}

output "subnet_names" {
  description = "Map of names of subnets"
  value = { for key, name in zipmap(
    sort(keys(var.spoke_subnets)),
    sort(values(azurerm_subnet.default_snet)[*]["name"])) :
  key => { key = key, name = name } }
}

output "subnet_address_prefixes" {
  description = "List of address prefix for subnets"
  value       = flatten(concat([for s in azurerm_subnet.default_snet : s.address_prefixes]))
}

# Network Security group ids
output "network_security_group_ids" {
  description = "Map of ids for default NSGs"
  value = { for key, id in zipmap(
    sort(keys(var.spoke_subnets)),
    sort(values(azurerm_network_security_group.nsg)[*]["id"])) :
  key => { key = key, id = id } }
}

output "network_security_group_names" {
  description = "Map of names for default NSGs"
  value = { for key, name in zipmap(
    sort(keys(var.spoke_subnets)),
    sort(values(azurerm_network_security_group.nsg)[*]["name"])) :
  key => { key = key, name = name } }
}

# DDoS Protection Plan
output "ddos_protection_plan_id" {
  description = "Ddos protection plan details"
  value       = var.create_ddos_plan ? element(concat(azurerm_network_ddos_protection_plan.ddos.*.id, [""]), 0) : null
}

output "network_watcher_id" {
  description = "ID of Network Watcher"
  value       = data.azurerm_network_watcher.nwatcher.id
}

output "route_table_name" {
  description = "The name of the route table"
  value       = azurerm_route_table.routetable.name
}

output "route_table_id" {
  description = "The resource id of the route table"
  value       = azurerm_route_table.routetable.id
}

output "private_dns_zone_names" {
  description = "The name of the Private DNS zones within Azure DNS"
  value       = [for s in module.mod_pdz : s.private_dns_zone_name]
}

output "private_dns_zone_ids" {
  description = "The resource id of Private DNS zones within Azure DNS"
  value       = [for s in module.mod_pdz : s.private_dns_zone_id]
}

output "storage_account_id" {
  description = "The ID of the storage account."
  value       = module.mgt_storage_account_spoke.storage_account_id
}

output "storage_account_name" {
  description = "The name of the storage account."
  value       = module.mgt_storage_account_spoke.storage_account_name
}
