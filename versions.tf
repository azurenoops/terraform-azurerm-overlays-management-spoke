# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

terraform {
  required_version = ">= 1.3"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.36"
    }
    azurenoopsutils = {
      source  = "azurenoops/azurenoopsutils"
      version = "~> 1.0.4"
    }
  }
}

#-------------------------------------
# Azure Provider Alias for Peering
#-------------------------------------
provider "azurerm" {
  alias           = "hub"
  subscription_id = coalesce(data.azurerm_client_config.current.subscription_id, var.subscription_id_hub)
  features {}
}
