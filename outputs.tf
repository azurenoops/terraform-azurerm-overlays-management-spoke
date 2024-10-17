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
  value       = module.spoke_vnet.name
}

output "virtual_network_id" {
  description = "The id of the virtual network"
  value       = module.spoke_vnet.resource_id
}

output "virtual_network_address_space" {
  description = "List of address spaces that are used the virtual network."
  value       = module.spoke_vnet.resource.body.properties.addressSpace.addressPrefixes
}

output "subnet_ids" {
  description = "Map of IDs of subnets"
  value = { for key, id in zipmap(
    sort(keys(var.spoke_subnets)),
    sort(values(azurerm_subnet.default_snet)[*]["id"])) :
  key => { key = key, id = id } }
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
    sort(values(module.nsg)[*]["resource_id"])) :
  key => { key = key, id = id } }
}

output "network_security_group_names" {
  description = "Map of names for default NSGs"
  value = { for key, name in zipmap(
    sort(keys(var.spoke_subnets)),
    sort(values(module.nsg)[*]["name"])) :
  key => { key = key, name = name } }
}

# DDoS Protection Plan
output "ddos_protection_plan_id" {
  description = "Ddos protection plan details"
  value       = var.create_ddos_plan ? module.mod_spoke_vnet_ddos[0].resource.id : null
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

output "spoke_storage_account_id" {
  description = "The ID of the storage account."
  value       = module.spoke_st.resource_id
}

output "spoke_storage_account_name" {
  description = "The name of the storage account."
  value       = module.spoke_st.name
}

output "spoke_storage_account_private_endpoints" {
  description = "The private endpoints of the storage account."
  value       = module.spoke_st.private_endpoints
}

output "spoke_storage_account_cmk_user_assigned_identity_principal_id" {
  value = var.enable_customer_managed_keys ? azurerm_user_assigned_identity.user_assigned_identity[0].principal_id : null
}
