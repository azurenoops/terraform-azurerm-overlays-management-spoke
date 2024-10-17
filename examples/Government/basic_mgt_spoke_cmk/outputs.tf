# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

# Resource Group
output "resource_group_name" {
  description = "The name of the resource group in which resources are created"
  value       = module.mod_vnet_spoke.resource_group_name
}

output "resource_group_id" {
  description = "The id of the resource group in which resources are created"
  value       = module.mod_vnet_spoke.resource_group_id
}

output "resource_group_location" {
  description = "The location of the resource group in which resources are created"
  value       = module.mod_vnet_spoke.resource_group_location
}

#VNet and Subnets
output "virtual_network_name" {
  description = "The name of the virtual network"
  value       = module.mod_vnet_spoke.virtual_network_name
}

output "virtual_network_id" {
  description = "The id of the virtual network"
  value       = module.mod_vnet_spoke.virtual_network_id
}

output "virtual_network_address_space" {
  description = "List of address spaces that are used the virtual network."
  value       = module.mod_vnet_spoke.virtual_network_address_space
}

output "subnet_ids" {
  description = "Map of IDs of subnets"
  value       = module.mod_vnet_spoke.subnet_ids
}

output "subnet_names" {
  description = "Map of Names of subnets"
  value       = module.mod_vnet_spoke.subnet_names
}

output "subnet_address_prefixes" {
  description = "List of address prefix for subnets"
  value       = module.mod_vnet_spoke.subnet_address_prefixes
}

output "network_security_group_ids" {
  description = "List of Network security groups and ids"
  value       = module.mod_vnet_spoke.network_security_group_ids
}

output "network_security_group_names" {
  description = "List of Network security groups and ids"
  value       = module.mod_vnet_spoke.network_security_group_names
}

# DDoS Protection plan
output "ddos_protection_plan_id" {
  description = "Ddos protection plan details"
  value       = module.mod_vnet_spoke.ddos_protection_plan_id
}

# Network Watcher
output "network_watcher_id" {
  description = "ID of Network Watcher"
  value       = module.mod_vnet_spoke.network_watcher_id
}

# Route Table
output "route_table_name" {
  description = "The name of the route table"
  value       = module.mod_vnet_spoke.route_table_name
}

output "route_table_id" {
  description = "The resource id of the route table"
  value       = module.mod_vnet_spoke.route_table_id
}

# Storage Account
output "storage_account_id" {
  description = "The ID of the storage account."
  value       = module.mod_vnet_spoke.storage_account_id
}

output "storage_account_name" {
  description = "The name of the storage account."
  value       = module.mod_vnet_spoke.storage_account_name
}



