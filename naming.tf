# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

#------------------------------------------------------------
# Azure NoOps Naming - This should be used on all resource naming
#------------------------------------------------------------
data "azurenoopsutils_resource_name" "vnet" {
  name          = var.workload_name
  resource_type = "azurerm_virtual_network"
  prefixes      = [var.org_name, var.use_location_short_name ? module.mod_azregions.location_short : module.mod_azregions.location_cli]
  suffixes      = compact([var.name_prefix == "" ? null : local.name_prefix, var.deploy_environment, local.name_suffix, var.use_naming ? "" : "vnet"])
  use_slug      = var.use_naming
  clean_input   = true
  separator     = "-"
}

data "azurenoopsutils_resource_name" "snet" {
  for_each      = var.spoke_subnets
  name          = var.workload_name
  resource_type = "azurerm_subnet"
  prefixes      = [var.org_name, var.use_location_short_name ? module.mod_azregions.location_short : module.mod_azregions.location_cli]
  suffixes      = compact([var.name_prefix == "" ? null : local.name_prefix, var.deploy_environment, each.value.name, local.name_suffix, var.use_naming ? "" : "snet"])
  use_slug      = var.use_naming
  clean_input   = true
  separator     = "-"
}

data "azurenoopsutils_resource_name" "nsg" {
  for_each      = var.spoke_subnets
  name          = var.workload_name
  resource_type = "azurerm_network_security_group"
  prefixes      = [var.org_name, var.use_location_short_name ? module.mod_azregions.location_short : module.mod_azregions.location_cli]
  suffixes      = compact([var.name_prefix == "" ? null : local.name_prefix, var.deploy_environment, each.value.name, local.name_suffix, var.use_naming ? "" : "nsg"])
  use_slug      = var.use_naming
  clean_input   = true
  separator     = "-"
}

data "azurenoopsutils_resource_name" "rt" {
  name          = var.workload_name
  resource_type = "azurerm_route_table"
  prefixes      = [var.org_name, var.use_location_short_name ? module.mod_azregions.location_short : module.mod_azregions.location_cli]
  suffixes      = compact([var.name_prefix == "" ? null : local.name_prefix, var.deploy_environment, local.name_suffix, var.use_naming ? "" : "route-table"])
  use_slug      = var.use_naming
  clean_input   = true
  separator     = "-"
}

data "azurenoopsutils_resource_name" "st" {
  name          = random_id.uniqueString.hex
  resource_type = "azurerm_storage_account"
  prefixes      = [var.org_name, var.use_location_short_name ? module.mod_azregions.location_short : module.mod_azregions.location_cli]
  suffixes      = compact([var.name_prefix == "" ? null : local.name_prefix, var.deploy_environment, local.name_suffix, var.use_naming ? "" : "st"])
  use_slug      = var.use_naming
}

data "azurenoopsutils_resource_name" "ddos" {
  name          = var.workload_name
  resource_type = "azurerm_network_ddos_protection_plan"
  prefixes      = [var.org_name, var.use_location_short_name ? module.mod_azregions.location_short : module.mod_azregions.location_cli]
  suffixes      = compact([var.name_prefix == "" ? null : local.name_prefix, var.deploy_environment, local.name_suffix, var.use_naming ? "" : "ddospp"])
  use_slug      = var.use_naming
  clean_input   = true
  separator     = "-"
}

data "azurenoopsutils_resource_name" "pe" {
  name          = var.workload_name
  resource_type = "azurerm_private_endpoint"
  prefixes      = [var.org_name, var.use_location_short_name ? module.mod_azregions.location_short : module.mod_azregions.location_cli]
  suffixes      = compact([var.name_prefix == "" ? null : local.name_prefix, var.deploy_environment, local.name_suffix, var.use_naming ? "" : "pe"])
  use_slug      = var.use_naming
  clean_input   = true
  separator     = "-"
}

data "azurenoopsutils_resource_name" "psc" {
  name          = var.workload_name
  resource_type = "azurerm_private_service_connection"
  prefixes      = [var.org_name, var.use_location_short_name ? module.mod_azregions.location_short : module.mod_azregions.location_cli]
  suffixes      = compact([var.name_prefix == "" ? null : local.name_prefix, var.deploy_environment, local.name_suffix, var.use_naming ? "" : "psc"])
  use_slug      = var.use_naming
  clean_input   = true
  separator     = "-"
}

data "azurenoopsutils_resource_name" "nic" {
  name          = var.workload_name
  resource_type = "azurerm_network_interface"
  prefixes      = [var.org_name, var.use_location_short_name ? module.mod_azregions.location_short : module.mod_azregions.location_cli]
  suffixes      = compact([var.name_prefix == "" ? null : local.name_prefix, var.deploy_environment, local.name_suffix, var.use_naming ? "" : "nic"])
  use_slug      = var.use_naming
  clean_input   = true
  separator     = "-"
}
