
#----------------------------------------------------------------
# Azure Role Assignment for Service Principal - current user
#-----------------------------------------------------------------
resource "azurerm_role_assignment" "peering" {
  scope                = module.spoke_vnet.vnet_resource.id
  role_definition_name = "Network Contributor"
  principal_id         = data.azurerm_client_config.current.object_id
}

resource "azurerm_role_assignment" "storage" {
  scope                = module.spoke_st.id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = data.azurerm_client_config.current.object_id
}
