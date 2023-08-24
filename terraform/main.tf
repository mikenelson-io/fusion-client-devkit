terraform {
  required_providers {
    fusion = {
      source = "PureStorage-OpenConnect/fusion"
      version = "1.0.16"
    }
  }
}

provider "fusion" {
}

resource "fusion_tenant_space" "fts" {
  name         = var.tenant_space_name
  display_name = var.tenant_space_name
  tenant       = var.tenant_name
}

resource "fusion_placement_group" "placement_group" {
  name                        = "pg1"
  display_name                = "pg1"
  tenant                      = var.tenant_name
  tenant_space                = fusion_tenant_space.fts.name
  region                      = var.region_name
  availability_zone           = var.availability_zone
  storage_service             = var.storage_service
  destroy_snapshots_on_delete = true
}

resource "fusion_volume" "vol1" {
  name                 = "vol1"
  display_name         = "Volume 1"
  tenant               = var.tenant_name
  tenant_space         = fusion_tenant_space.fts.name
  size                 = 1000000000
  placement_group      = fusion_placement_group.placement_group.name
  storage_class        = var.storage_class
  host_access_policies = ["myhost"]
  eradicate_on_delete  = true
}
