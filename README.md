![](https://github.com/PureStorage-OpenConnect/fusion-client-devkit/blob/main/images/Pure%20Fusion%20icon%20logo.png) 
[![Docker Repository on Quay](https://quay.io/repository/purestorage/fusion-devkit/status "Docker Repository on Quay")](https://quay.io/repository/purestorage/fusion-devkit)
# Setting up your Fusion DevKit Client
This repository is to help you set up a machine that will install and configure the necessary tools to connect to your Fusion environment.

If you need a high level overview of Pure Fusion please check out [this Youtube playlist](https://youtube.com/playlist?list=PLZcmbL4tTCUwv8UdACFAQZbkTtEjzob5I).
## Prerequisites
 - A Pure Fusion control plane
 - Pure1 Edge Services enabled in Pure1
 - 1 or more FlashArrays configured with the Fusion Agents installed
 - An API Client ("Application") registered with Pure1 along with it's associated private key. This API key will need Pure1 Admin permissions. The private key file must be an RSA key. Please refer to ths guide for creating the proper keys:

    - [API Client Creation Guide](https://support.purestorage.com/Pure_Fusion/Getting_Started_with_Pure_Fusion/Creating_and_API_Client%2F%2FApplication_Access_for_Fusion_or_Pure1_API_access)

 - Operating system compatability. The intial build of the DevKit was tested on Ubuntu 20.04. Since the DevKit can run as a Docker container, it should run on any platform supported by a Linux container. If using the Installer method, then the OS must be CentOS or Ubuntu.
 *Pull requests welcomed for other tested operating systems*
	 - An x86-64 Ubuntu linux machine
	    - Windows WSL2 or a virtual machine
	    - If not running native Docker, install Docker Desktop for the DevKit container
	- An Apple Silicon (arm64) or Intel (amd64) machine
	    - Docker Desktop installed
	    - wget installed

## Setting up the Tools
There are 2 main ways to get access to the tools:
 - Downloading and using the pre-built Docker image
 - Running the installer to install the tools natively

**Using the Pre-built Docker Image**

 - Notes: 
	 - Install Docker Desktop before proceeding for WSL2 and MacOS or Windows. If using WSL2 in Windows, ensure Docker Desktop is enabled for your distribution in the Docker Resource settings
	 - If running on MacOS, install `wget` before proceeding (ex. `brew install wget`)
	 - Replace API_CLIENT_ID with the APP ID from Pure1.
	 - Replace PATH_TO_PRIV_KEY with the absolute path to the private key.pem file
```
# Pull the Docker image:
docker pull quay.io/purestorage/fusion-devkit
# If necessary, you may download the image .tar file directly and import it manually into Docker:
      wget https://github.com/PureStorage-OpenConnect/fusion-client-devkit/releases/latest/download/fusion-devkit.tar
      docker load < fusion-devkit.tar
# Create the folder and copy the required key and file:
mkdir api-client
echo API_CLIENT_ID > api-client/issuer
cp PATH_TO_PRIV_KEY api-client/
```
## Spin up the Container
```
# For the command lines below, replace <image_name> with either 'quay.io/purestorage/fusion-devkit' (if pulled from quay.io), or 'fusion-devkit' if downloaded manually.

# For amd64:
docker run -it -v `pwd`/api-client:/api-client <image_name> bash

# For Apple Silicon arm64:
docker run --platform linux/amd64 -it -v `pwd`/api-client:/api-client <image_name> bash

# To access the Fusion Swagger interface on port 8080 of localhost:
docker run -p 8080:8080 -v `pwd`/api-client:/api-client <image_name> bash
```

### Using the Installer bash script - CentOS or Ubuntu only (WSLv2/BareMetal/VM)
```
# Clone the repository:
git clone https://github.com/PureStorage-OpenConnect/fusion-client-devkit.git `pwd`/fusion-devkit-setup
# Move into the folder and run the setup.sh script, replacing the two variables with the proper key and path:
cd fusion-devkit-setup
sudo chmod +x setup.sh
./setup.sh API_CLIENT_ID PATH_TO_PRIV_KEY
```

## Tools currently available
These are the tools currently provided in the DevKit:

### Fusion Swagger (Container image only)
The Swagger interface for the Fusion API is included in the container image. To launch Swagger to view on the local desktop, you must expose the local tcp 8080 port via the ```-p <port>:8080``` parameter in the Docker run command. As an example:
``` docker run -p 1234:8080 -v `pwd`/api-client:/api-client <image_name> bash ```

### HMCTL
HMCTL is the remote CLI utility provided with Fusion.

To check if HMCTL was configured correctly, run
```
hmctl version
```
After this install you should be able to run commands as seen in [this guide](https://support.purestorage.com/Pure_Fusion/Pure_Fusion_for_Storage_Consumers/Example_CLI_Commands).

### Python
Our Python library has full support for all Fusion APIs.

To run a smoke test:
```
python3 python/00_smoke_test.py
```
After installation is complete, you can refer to [the documentation](https://github.com/PureStorage-OpenConnect/fusion-python-sdk) for guidance on writing your own Python scripts.

### Ansible
Our Ansible collection has full support for all Fusion APIs.

To run a smoke test:
```
ansible-playbook smoke_test.yml
```
After installation, you can check out the ansible collection from the [Ansible documentation page here](https://docs.ansible.com/ansible/latest/collections/purestorage/fusion/index.html#plugins-in-purestorage-fusion) for more information on the individual modules.

### Terraform (Installer Only - not in container image just yet)
Our Terraform provider supports consumer workflows in Fusion. Terraform does not allow for a full smoke test since it is a consumer-focused provider and requires more Fusion configuration before it can execute.

After installation, you can see the [Terraform module documentation here](https://registry.terraform.io/providers/PureStorage-OpenConnect/fusion/1.0.0) for guidance on writing your own Terraform templates.
