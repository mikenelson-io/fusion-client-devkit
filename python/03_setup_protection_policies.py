import pathlib

import fusion
import yaml

from utils import get_fusion_config, wait_operation_succeeded


def setup_protection_policies():
    print("Setting up protection policies")

    # create an API client with your access Configuration
    config = get_fusion_config()
    client = fusion.ApiClient(config)

    # get needed API clients
    pp = fusion.ProtectionPoliciesApi(api_client=client)

    # Load configuration
    with open(pathlib.Path(__file__).parent / "config/policy.yaml") as file:
        protection_policies = yaml.safe_load(file)["protection_policies"]

    # Create protection_policies
    for protection_policy in protection_policies:
        print("Creating protection policy", protection_policy["name"])
        current_protection_policy = fusion.ProtectionPolicyPost(
            name=protection_policy["name"],
            display_name=protection_policy["display_name"],
            objectives=protection_policy["objectives"]
        )
        try:
            api_response = pp.create_protection_policy(current_protection_policy)
            # pprint(api_response)
            wait_operation_succeeded(api_response.id, client)
        except Exception as e:
            print("Exception when calling ProtectionPoliciesAPI->create_protection_policy: %s\n" % e)
    print("Done setting up protection policies!")


if __name__ == '__main__':
    setup_protection_policies()
