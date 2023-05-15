# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

/*
SUMMARY: Module Example to deploy an Private DNS Zones to a spoke 
DESCRIPTION: The following components will be options in this deployment
            * Private DNS Zones 
AUTHOR/S: jspinella
*/

#----------------------------------------
# Private DNS Zone
#----------------------------------------
module "mod_pdz" {
  source                      = "./modules/private_dns_zone"
  for_each                    = toset(var.private_dns_zones)
  private_dns_zone_name       = each.key
  resource_group_name         = local.resource_group_name
  vm_autoregistration_enabled = true
  private_dns_zone_vnets_ids = [
    var.hub_virtual_network_id,
    azurerm_virtual_network.spoke_vnet.id,
  ]
  add_tags = merge({ "ResourceName" = format("%s", lower(each.key)) }, local.default_tags, var.add_tags, )
}
