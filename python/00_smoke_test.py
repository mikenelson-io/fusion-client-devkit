from __future__ import print_function

from pprint import pprint

import fusion
from fusion.rest import ApiException

from utils import get_fusion_config


def smoke_test():
    # create an API client with your access Configuration
    config = get_fusion_config()
    client = fusion.ApiClient(config)

    # create an API client for Storage Services
    ss_client = fusion.StorageServicesApi(client)

    try:
        api_response = ss_client.list_storage_services()
        pprint(api_response)
    except ApiException as e:
        print("Exception when listing storage services: %s\n" % e)


if __name__ == '__main__':
    smoke_test()
