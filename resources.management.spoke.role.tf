
#----------------------------------------------------------------
# Azure Role Assignment for Service Principal - current user
#-----------------------------------------------------------------
resource "azurerm_role_assignment" "peering" {
  scope                = module.spoke_vnet.vnet_resource.id
  role_definition_name = "Network Contributor"
  principal_id         = data.azurerm_client_config.current.object_id
}
