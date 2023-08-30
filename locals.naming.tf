locals {
  # Naming locals/constants
  name_prefix = lower(var.name_prefix)
  name_suffix = lower(var.name_suffix)

  resource_group_name    = element(coalescelist(data.azurerm_resource_group.rgrp.*.name, module.mod_scaffold_rg.*.resource_group_name, [""]), 0)
  location               = element(coalescelist(data.azurerm_resource_group.rgrp.*.location, module.mod_scaffold_rg.*.resource_group_location, [""]), 0)
  spoke_vnet_name        = coalesce(var.custom_spoke_virtual_network_name, data.azurenoopsutils_resource_name.vnet.result)  
  spoke_rt_name          = coalesce(var.custom_spoke_route_table_name, "${data.azurenoopsutils_resource_name.rt.result}")
  spoke_sa_name          = coalesce(var.custom_spoke_storage_account_name, data.azurenoopsutils_resource_name.st.result)
  
  # DDOS Protection Plan
  ddos_plan_name = coalesce(var.ddos_plan_custom_name, "${data.azurenoopsutils_resource_name.ddos.result}")
}
