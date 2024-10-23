# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

#----------------------------------------------
# Log Analytics Workspace
#----------------------------------------------
data "azurerm_client_config" "root" {}

resource "azurerm_resource_group" "uai_rg" {
  name     = "uai-rg-${var.default_location}-${var.org_name}"
  location = var.default_location
}

# Create a User Assigned Identity for Azure Encryption
resource "azurerm_user_assigned_identity" "spoke_user_assigned_identity" {
  location            = var.default_location
  resource_group_name = azurerm_resource_group.uai_rg.name
  name                = "spoke-st-usi"
}

resource "azurerm_role_assignment" "spoke_uai_role_assignment" {
  scope                = data.azurerm_key_vault.kv.id
  role_definition_name = "Key Vault Crypto Officer"
  principal_id         = azurerm_user_assigned_identity.spoke_user_assigned_identity.principal_id
  
}