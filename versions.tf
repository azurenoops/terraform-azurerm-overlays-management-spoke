# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

terraform {
  required_version = ">= 1.3"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.22"
    }
    azurenoopsutils = {
      source  = "azurenoops/azurenoopsutils"
      version = "~> 1.0.4"
    }
  }
}

provider "azurerm" {
  features {}
}

#-------------------------------------
# Azure Provider Alias for Peering
#-------------------------------------
provider "azurerm" {
  alias           = "hub_network"
  subscription_id = coalesce(element(split("/", var.hub_virtual_network_id), 2), data.azurerm_client_config.current.subscription_id)
  features {}
}
