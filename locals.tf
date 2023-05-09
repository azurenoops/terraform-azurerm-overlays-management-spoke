# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

# remove file if not needed

#---------------------------------
# Local declarations
#---------------------------------
resource "random_id" "uniqueString" {
  keepers = {
    # Generate a new id each time we change resourePrefix variable
    org_prefix = var.org_name
    subid      = var.workload_name
  }
  byte_length = 8
}

locals {
  if_ddos_enabled = var.create_ddos_plan ? [{}] : []
}