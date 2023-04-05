import fusion
from fusion.rest import ApiException

from utils import get_fusion_config, wait_operation_succeeded


def teardown_tenants():
    print("Tearing down tenants")

    # create an API client with your access Configuration
    config = get_fusion_config()
    client = fusion.ApiClient(config)

    # get needed API clients
    t = fusion.TenantsApi(api_client=client)

    engineering = fusion.TenantPost(name='engineering', display_name='engineering')
    finance = fusion.TenantPost(name='finance', display_name='finance')
    oracle_dbas = fusion.TenantPost(name='oracle_dbas', display_name='oracle_dbas')

    # Get all Tenants
    try:
        t_list = t.list_tenants()
        # pprint(t_list)
    except ApiException as e:
        print("Exception when calling TenantsApi->list_tenants: %s\n" % e)
    for tenant in t_list.items:
        # Delete Tenant
        print("Deleting tenant", tenant.name)
        try:
            api_response = t.delete_tenant(tenant.name)
            # pprint(api_response)
            wait_operation_succeeded(api_response.id, client)
        except ApiException as e:
            print("Exception when calling TenantsApi->delete_tenant: %s\n" % e)
    print("Done tearing down tenants!")


if __name__ == '__main__':
    teardown_tenants()
