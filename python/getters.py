import fusion


def array_getter(client, region_name, availability_zone_name, array_name):
    """Returns get Array function"""

    def get_array():
        """Get Array or None"""
        array_api_instance = fusion.ArraysApi(client)
        try:
            return array_api_instance.get_array(
                array_name=array_name,
                availability_zone_name=availability_zone_name,
                region_name=region_name,
            )
        except fusion.rest.ApiException:
            return None

    return get_array


def availability_zone_getter(client, region_name, availability_zone_name):
    """Returns get Availability Zone function"""

    def get_az():
        """Get Availability Zone or None"""
        az_api_instance = fusion.AvailabilityZonesApi(client)
        try:
            return az_api_instance.get_availability_zone(
                region_name=region_name,
                availability_zone_name=availability_zone_name,
            )
        except fusion.rest.ApiException:
            return None

    return get_az


def region_getter(client, region_name):
    """Returns get Region function"""

    def get_region():
        """Get Region or None"""
        region_api_instance = fusion.RegionsApi(client)
        try:
            return region_api_instance.get_region(
                region_name=region_name,
            )
        except fusion.rest.ApiException:
            return None

    return get_region


def storage_service_getter(client, storage_service_name):
    """Returns get Storage Sevice function"""

    def get_ss():
        """Return Storage Service or None"""
        ss_api_instance = fusion.StorageServicesApi(client)
        try:
            return ss_api_instance.get_storage_service(
                storage_service_name=storage_service_name
            )
        except fusion.rest.ApiException:
            return None

    return get_ss


def storage_class_getter(client, storage_sevice_name, storage_class_name):
    """Returns get Storage Class function"""

    def get_sc():
        """Return Storage Class or None"""
        sc_api_instance = fusion.StorageClassesApi(client)
        try:
            return sc_api_instance.get_storage_class(
                storage_service_name=storage_sevice_name,
                storage_class_name=storage_class_name,
            )
        except fusion.rest.ApiException:
            return None

    return get_sc


def protection_policy_getter(client, protection_policy_name):
    """Returns get Protection Policy function"""

    def get_pp():
        """Return Protection Policy or None"""
        sc_api_instance = fusion.ProtectionPoliciesApi(client)
        try:
            return sc_api_instance.get_protection_policy(
                protection_policy_name=protection_policy_name,
            )
        except fusion.rest.ApiException:
            return None

    return get_pp


def network_interface_getter(client, region_name, availability_zone_name, network_interface_group_name):
    """Returns get Network Interface Group function"""

    def get_nig():
        """Return Network Interface Group or None"""
        api_instance = fusion.NetworkInterfaceGroupsApi(client)
        try:
            return api_instance.get_network_interface_group(region_name=region_name,
                                                            availability_zone_name=availability_zone_name,
                                                            network_interface_group_name=network_interface_group_name,
                                                            )
        except fusion.rest.ApiException:
            return None

    return get_nig


def storage_endpoint_getter(client, region_name, availability_zone_name, storage_endpoint_name):
    """Returns get Storage Endpoint function"""

    def get_se():
        """Return Storage Endpoint  Group or None"""
        api_instance = fusion.StorageEndpointsApi(client)
        try:
            return api_instance.get_storage_endpoint(region_name=region_name,
                                                     availability_zone_name=availability_zone_name,
                                                     storage_endpoint_name=storage_endpoint_name,
                                                     )
        except fusion.rest.ApiException:
            return None

    return get_se


def tenant_getter(client, tenant_name):
    """Returns get Tenant function"""

    def get_tenant():
        """Return Tenant or None"""
        api_instance = fusion.TenantsApi(client)
        try:
            return api_instance.get_tenant(tenant_name=tenant_name)
        except fusion.rest.ApiException:
            return None

    return get_tenant


def tenant_space_getter(client, tenant_name, tenant_space_name):
    """Returns get Tenant Space function"""

    def get_ts():
        """Tenant Space or None"""
        ts_api_instance = fusion.TenantSpacesApi(client)
        try:
            return ts_api_instance.get_tenant_space(
                tenant_name=tenant_name,
                tenant_space_name=tenant_space_name,
            )
        except fusion.rest.ApiException:
            return None

    return get_ts


def placement_group_getter(client, tenant_name, tenant_space_name, placement_group_name):
    """Returns get Placement Group function"""

    def get_pg():
        """Placement Group or None"""
        ts_api_instance = fusion.PlacementGroupsApi(client)
        try:
            return ts_api_instance.get_placement_group(
                tenant_name=tenant_name,
                tenant_space_name=tenant_space_name,
                placement_group_name=placement_group_name
            )
        except fusion.rest.ApiException:
            return None

    return get_pg

def host_access_policy_getter(client, host_access_policy_name):
    """Returns get Host Access Policy function"""

    def get_hap():
        """Host Access Policy or None"""
        ts_api_instance = fusion.HostAccessPoliciesApi(client)
        try:
            return ts_api_instance.get_host_access_policy(
                host_access_policy_name=host_access_policy_name
            )
        except fusion.rest.ApiException:
            return None

    return get_hap

def volume_getter(client, tenant_name, tenant_space_name, volume_name):
    """Returns get Volumefunction"""

    def get_vol():
        """Placement Group or None"""
        ts_api_instance = fusion.VolumesApi(client)
        try:
            return ts_api_instance.get_volume(
                tenant_name=tenant_name,
                tenant_space_name=tenant_space_name,
                volume_name=volume_name,
            )
        except fusion.rest.ApiException:
            return None

    return get_vol