# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

/*
SUMMARY: Terraform Module to deploy the Management Spoke Network based on the Azure Mission Landing Zone conceptual architecture
DESCRIPTION: The following components will be options in this deployment
              * Management Spoke Network Virtual Network
              * Ddos Protection Plan
              * Network Watcher
AUTHOR/S: jrspinella
*/

#-------------------------------------
# VNET Creation - Default is "true"
#-------------------------------------
module "spoke_vnet" {
  source  = "azure/avm-res-network-virtualnetwork/azurerm"
  version = "0.4.2"

  # Resource Group
  name                = local.spoke_vnet_name
  resource_group_name = local.resource_group_name
  location            = local.location

  # Virtual Network DNS Servers
  dns_servers = {
    dns_servers = var.dns_servers
  }

  # Virtual Network Address Space
  address_space = var.virtual_network_address_space

  # Ddos protection plan - Default is "false"
  ddos_protection_plan = var.create_ddos_plan ? {
    enable = true
    id     = module.mod_spoke_vnet_ddos[0].resource.id
  } : null

  role_assignments = {
    role_assignment_nw_peering = {
      role_definition_id_or_name       = "Network Contributor"
      principal_id                     = data.azurerm_client_config.current.object_id
      skip_service_principal_aad_check = false
    },
  }

  # Resource Lock
  lock = var.enable_resource_locks ? {
    name = "${local.spoke_vnet_name}-${var.lock_level}-lock"
    kind = var.lock_level
  } : null

   # telemtry
  enable_telemetry = var.disable_telemetry

  # Tags
  tags = merge({ "ResourceName" = format("%s", local.spoke_vnet_name) }, local.default_tags, var.add_tags, )
}

#--------------------------------------------
# Ddos protection plan - Default is "false"
#--------------------------------------------
module "mod_spoke_vnet_ddos" {
  source              = "azure/avm-res-network-ddosprotectionplan/azurerm"
  version             = "0.2.0"
  count               = var.create_ddos_plan ? 1 : 0
  name                = local.ddos_plan_name
  resource_group_name = local.resource_group_name
  location            = local.location

  # Resource Lock
  lock = var.enable_resource_locks ? {
    name = "${local.ddos_plan_name}-${var.lock_level}-lock"
    kind = var.lock_level
  } : null

  tags = merge({ "ResourceName" = format("%s", local.ddos_plan_name) }, local.default_tags, var.add_tags, )
}

