import fusion


def array_getter(array_api_instance: fusion.ArraysApi, region_name, availability_zone_name, array_name):
    """Returns get Array function"""

    def get_array():
        """Get Array or None"""
        try:
            return array_api_instance.get_array(
                array_name=array_name,
                availability_zone_name=availability_zone_name,
                region_name=region_name,
            )
        except fusion.rest.ApiException:
            return None

    return get_array


def availability_zone_getter(az_api_instance: fusion.AvailabilityZonesApi, region_name, availability_zone_name):
    """Returns get Availability Zone function"""

    def get_az():
        """Get Availability Zone or None"""
        try:
            return az_api_instance.get_availability_zone(
                region_name=region_name,
                availability_zone_name=availability_zone_name,
            )
        except fusion.rest.ApiException:
            return None

    return get_az


def region_getter(region_api_instance: fusion.RegionsApi, region_name):
    """Returns get Region function"""

    def get_region():
        """Get Region or None"""
        try:
            return region_api_instance.get_region(
                region_name=region_name,
            )
        except fusion.rest.ApiException:
            return None

    return get_region


def storage_service_getter(ss_api_instance: fusion.StorageService, storage_service_name):
    """Returns get Storage Sevice function"""

    def get_ss():
        """Return Storage Service or None"""
        try:
            return ss_api_instance.get_storage_service(
                storage_service_name=storage_service_name
            )
        except fusion.rest.ApiException:
            return None

    return get_ss


def storage_class_getter(sc_api_instance: fusion.StorageClass, storage_sevice_name, storage_class_name):
    """Returns get Storage Class function"""

    def get_sc():
        """Return Storage Class or None"""
        try:
            return sc_api_instance.get_storage_class(
                storage_service_name=storage_sevice_name,
                storage_class_name=storage_class_name,
            )
        except fusion.rest.ApiException:
            return None

    return get_sc


def protection_policy_getter(pp_api_instance: fusion.ProtectionPoliciesApi, protection_policy_name):
    """Returns get Protection Policy function"""

    def get_pp():
        """Return Protection Policy or None"""
        try:
            return pp_api_instance.get_protection_policy(
                protection_policy_name=protection_policy_name,
            )
        except fusion.rest.ApiException:
            return None

    return get_pp


def network_interface_groups_getter(nig_api_instance: fusion.NetworkInterfacesApi, region_name, availability_zone_name, network_interface_group_name):
    """Returns get Network Interface Group function"""

    def get_nig():
        """Return Network Interface Group or None"""
        try:
            return nig_api_instance.get_network_interface_group(region_name=region_name,
                                                               availability_zone_name=availability_zone_name,
                                                               network_interface_group_name=network_interface_group_name,
                                                               )
        except fusion.rest.ApiException:
            return None

    return get_nig


def storage_endpoint_getter(se_instance: fusion.StorageEndpointsApi, region_name, availability_zone_name, storage_endpoint_name):
    """Returns get Storage Endpoint function"""

    def get_se():
        """Return Storage Endpoint  Group or None"""
        try:
            return se_instance.get_storage_endpoint(region_name=region_name,
                                                    availability_zone_name=availability_zone_name,
                                                    storage_endpoint_name=storage_endpoint_name,
                                                    )
        except fusion.rest.ApiException:
            return None

    return get_se


def tenant_getter(tenant_api_instance: fusion.TenantsApi, tenant_name):
    """Returns get Tenant function"""

    def get_tenant():
        """Return Tenant or None"""
        try:
            return tenant_api_instance.get_tenant(tenant_name=tenant_name)
        except fusion.rest.ApiException:
            return None

    return get_tenant


def tenant_space_getter(ts_api_instance: fusion.TenantSpacesApi, tenant_name, tenant_space_name):
    """Returns get Tenant Space function"""

    def get_ts():
        """Tenant Space or None"""
        try:
            return ts_api_instance.get_tenant_space(
                tenant_name=tenant_name,
                tenant_space_name=tenant_space_name,
            )
        except fusion.rest.ApiException:
            return None

    return get_ts


def placement_group_getter(pg_api_instance: fusion.PlacementGroupsApi, tenant_name, tenant_space_name, placement_group_name):
    """Returns get Placement Group function"""

    def get_pg():
        """Placement Group or None"""
        try:
            return pg_api_instance.get_placement_group(
                tenant_name=tenant_name,
                tenant_space_name=tenant_space_name,
                placement_group_name=placement_group_name
            )
        except fusion.rest.ApiException:
            return None

    return get_pg


def host_access_policy_getter(hap_api_instance: fusion.HostAccessPoliciesApi, host_access_policy_name):
    """Returns get Host Access Policy function"""

    def get_hap():
        """Host Access Policy or None"""
        try:
            return hap_api_instance.get_host_access_policy(
                host_access_policy_name=host_access_policy_name
            )
        except fusion.rest.ApiException:
            return None

    return get_hap


def volume_getter(vol_api_instance: fusion.VolumesApi, tenant_name, tenant_space_name, volume_name):
    """Returns get Volumefunction"""

    def get_vol():
        """Placement Group or None"""
        try:
            return vol_api_instance.get_volume(
                tenant_name=tenant_name,
                tenant_space_name=tenant_space_name,
                volume_name=volume_name,
            )
        except fusion.rest.ApiException:
            return None

    return get_vol
