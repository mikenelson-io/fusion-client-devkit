terraform {
  required_providers {
    fusion = {
      source = "PureStorage-OpenConnect/fusion"
      version = "1.0.15"
    }
  }
}

provider "fusion" {
  host = var.hm_url
}

resource "fusion_tenant_space" "fts" {
  name         = var.tenant_space_name
  display_name = var.tenant_space_name
  tenant       = var.tenant_name
}

resource "fusion_placement_group" "placement_group" {
  name                   = "pg1"
  display_name           = "pg1"
  tenant_name            = var.tenant_name
  tenant_space_name      = fusion_tenant_space.fts.name
  region_name            = var.region_name
  availability_zone_name = var.availability_zone
  storage_service_name   = var.storage_service
  destroy_snapshots_on_delete = true
}

resource "fusion_volume" "vol1" {
  name                   = "vol1"
  display_name           = "Volume 1"
  tenant_name            = var.tenant_name
  tenant_space_name      = fusion_tenant_space.fts.name
  size                   = 1000000000
  placement_group_name   = fusion_placement_group.placement_group.name
  storage_class_name     = var.storage_class
  host_names             = ["myhost"]
}
