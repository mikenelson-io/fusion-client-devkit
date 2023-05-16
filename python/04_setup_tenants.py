import pathlib

import fusion
import yaml

from utils import get_fusion_config, wait_operation_succeeded, ResourceNameReserved
import getters


def setup_tenants():
    print("Setting up tenants")

    # create an API client with your access Configuration
    config = get_fusion_config()
    client = fusion.ApiClient(config)

    # get needed API clients
    t = fusion.TenantsApi(api_client=client)

    # Load configuration
    with open(pathlib.Path(__file__).parent / "config/tenants.yaml") as file:
        tenants = yaml.safe_load(file)

    # Create Tenants
    for tenant in tenants:
        print("Creating tenant", tenant["name"])
        current_tenant = fusion.TenantPost(name=tenant["name"], display_name=tenant["display_name"])
        try:
            api_response = t.create_tenant(current_tenant)
            # pprint(api_response)
            wait_operation_succeeded(api_response.id, client, resource_getter=getters.tenant_getter(t, current_tenant.name))
        except ResourceNameReserved as e:
            if not e.resource_exists:
                raise e
        except Exception as e:
            raise RuntimeError("Exception when calling TenantsAPI->create_tenant") from e

    print("Done setting up tenants!")


if __name__ == '__main__':
    setup_tenants()
