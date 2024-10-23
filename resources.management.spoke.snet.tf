# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

/*
SUMMARY: Module to deploy a subnet in the Management Spoke Network based on the Azure Mission Landing Zone conceptual architecture
DESCRIPTION: The following components will be options in this deployment
              * Management Spoke Subnets
AUTHOR/S: jrspinella
*/

#--------------------------------------------------------------------------------------------------------
# Subnets Creation with, private link endpoint/service network policies, service endpoints and Delegation.
#--------------------------------------------------------------------------------------------------------

module "default_snet" {
  source   = "azure/avm-res-network-virtualnetwork/azurerm//modules/subnet"
  version  = "0.4.2"
  depends_on = [ module.spoke_vnet ]
  for_each = var.spoke_subnets

  # Resource Name
  name                 = var.custom_spoke_subnet_name != null ? "${var.custom_spoke_subnet_name}_${each.key}" : "${data.azurenoopsutils_resource_name.snet[each.key].result}"
  
  # Virtual Networks
  virtual_network = {
    resource_id = module.spoke_vnet.resource_id
  }

  # Subnet Information
  address_prefixes  = each.value.address_prefixes
  service_endpoints = lookup(each.value, "service_endpoints", [])
  # Applicable to the subnets which used for Private link endpoints or services
  private_endpoint_network_policies             = lookup(each.value, "private_endpoint_network_policies_enabled", null)
  private_link_service_network_policies_enabled = lookup(each.value, "private_link_service_network_policies_enabled", null)
}