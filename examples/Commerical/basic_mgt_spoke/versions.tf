# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

provider "azurerm" {
  subscription_id = var.subscription_id
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
  skip_provider_registration = true
  storage_use_azuread        = true
}

provider "azurerm" {
  subscription_id = var.subscription_id
  alias = "hub"
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
  skip_provider_registration = true
  storage_use_azuread        = true
}

provider "azurerm" {
  subscription_id = "add23b29-a7e7-4b50-9a4d-3c39743bf1a7"
  alias = "ops"
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
  skip_provider_registration = true
  storage_use_azuread        = true
}


