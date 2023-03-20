# Pure Fusion DevKit &nbsp;&nbsp;<img src='images/Pure%20Fusion%20icon%20logo.png' width='100' align='center'>

[![Docker Repository on Quay](https://quay.io/repository/purestorage/fusion-devkit/status "Docker Repository on Quay")](https://quay.io/repository/purestorage/fusion-devkit)  ![GitHub version](https://img.shields.io/github/v/release/PureStorage-OpenConnect/fusion-client-devkit?color=orange)
## Setting up your Fusion DevKit Client
:warning: _The code and instructions in this repository are **BETA** at this time. This project is currently provided under the SLA of "best effort" support by the Pure Fusion Team. For feature requests and bugs, please use GitHub Issues and we actuvely encourage Pull requests for contributions to the code. We will address issues when resources allow._

This repository is to help you install and configure the necessary tools to connect to and interact with a Fusion environment. The toolsets that are included are the Fusion API Swagger, hmctl CLI tool, Python, Ansible, and Terraform.

If you would like a high level overview of Pure Fusion, please check out [this Youtube playlist](https://youtube.com/playlist?list=PLZcmbL4tTCUwv8UdACFAQZbkTtEjzob5I).

### Prerequisites
 - A Pure Fusion control plane supplied by Pure Storage
 - Pure1 Edge Services enabled in Pure1
 - One or more Pure FlashArrays configured with the Fusion Agent installed
 - An API Client ("Application") registered with Pure1 along with an associated private key file. This API key will need Pure1 Admin permissions for Provider access and no permissions for Consumer access. Please consult the API Client Creation document linked below for more information on Fusion roles and permissions. The private key file must be an RSA key. Please refer to ths guide for creating the proper ID and keys:

    - [API Client Creation Guide](https://support.purestorage.com/Pure_Fusion/Getting_Started_with_Pure_Fusion/Creating_and_API_Client%2F%2FApplication_Access_for_Fusion_or_Pure1_API_access)

 - Operating system compatability. The intial build of the DevKit was tested on Ubuntu 20.04 and Fedora 37. Since the DevKit can run as a Docker container, it should run on any platform supported by a Linux container. If using the Installer method, then currently only CentOS, Fedora, Ubuntu, or MacOS have been tested.

	 - x86-64 Ubuntu/CentOS/Fedora linux machine, which could be a bare metal machine, Windows WSLv2, or a virtual machine
	    - Docker or Docker Desktop for WSLv2. You can run Docker in WSLv2 without installing Docker Desktop.
	 - Apple Silicon (arm64) or Intel (amd64) machine running MacOS
	    - Docker Desktop or equivalent installed
	    - wget installed (for standalone script install)
	    - Xcode developer tools (for standalone script install)
	 - Windows x64 v10 or higher (for container image only)

:octocat: _Pull requests welcomed for other tested operating systems_

## Getting the Kit
There are two ways to get the tools:
 - Downloading and using the pre-built Docker image - recommended
 - Running the standalone installer scripts _(these will most likely not be supported for GA)_

## Docker Image (recommended method)

 - Notes: 
	 - For Windows (native) or MacOS, install Docker Desktop or equivalent before proceeding. You may use Docker Desktop for Windows if using WSLv2, but it is no longer necessary as you can run Docker in a WSLv2 distribution. If using WSLv2 in Windows with Docker Desktop, ensure  is enabled for your distribution in the Docker Desktop Resource settings. [See this article for more information.](https://docs.docker.com/desktop/windows/wsl/). Docker equivalents such as Podman and Multipass have not been tested, but will most likely work. 
	 - Replace API_CLIENT_ID with the APP ID from your Provider or Pure1.
	 - Replace PATH_TO_PRIV_KEY with the absolute path to the private key.pem file. The path must be absolute.

- Pull the Docker image:
```
docker pull quay.io/purestorage/fusion-devkit
```
:point_right: If necessary, you may download the image .tar file directly and import it manually into Docker:
```
wget https://github.com/PureStorage-OpenConnect/fusion-client-devkit/releases/latest/download/fusion-devkit.tar
docker load < fusion-devkit.tar
```
- Create the folder and copy the required APP ID and private-key.pem file

For Linux:
```
cd $HOME
mkdir api-client
echo API_CLIENT_ID > api-client/issuer
cp PATH_TO_PRIV_KEY api-client/
```
For Windows:
```
1) Open a command prompt or PowerShell window
2) Change directories into your User folder (Eg. cd C:\Users\fred)
3) Create the "api-client" folder (mkdir api-client)
4) Copy the APP ID to a new file called "issuer" (no file extension)
5) Copy the private-key.pem file
```
### Spin up the Container

_For the command lines below, replace <image_name> with either 'quay.io/purestorage/fusion-devkit' (if pulled from quay.io), or 'fusion-devkit' if downloaded manually from the GitHub repository._

```
# For Linux:
docker run -it --rm -v $HOME/api-client:/default-client <image_name> bash

# For Windows:
docker run -it --rm -v //c/Users/fred/api-client:/api-client <image_name> bash

# For Apple Silicon arm64:
docker run -it --rm -v $HOME/api-client:/default-client <image_name> bash

# To access the Fusion API Swagger web interface, you can specify a port (ex. 8080) on the localhost:

# Linux:
docker run -p 8080:8080 -v $HOME/api-client:/default-client <image_name> bash

# Windows:
docker run -p 8080:8080 -v //c/Users/fred/api-client:/default-client <image_name> bash

# arm64:
docker run -p 8080:8080 -v $HOME/api-client:/default-client <image_name> bash
```
### Aliases
For convenience, you can also add an alias to shorten your command line. An alias is native to Linux. For Windows, you could use [doskey](https://learn.microsoft.com/en-us/windows-server/administration/windows-commands/doskey), [PowerShell Set-Alias](https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.utility/set-alias?view=powershell-7.3), or create a .cmd file.
```
alias fusion-devkit="docker run -it --rm -v $HOME/api-client:/default-client <image_name> bash"

#### Creating multiple folders with different issuer and private-pem.key files allows for working with multiple configurations. You could then create multiple aliases to make it easier to switch between them:

alias fusion-devkit-admin="docker run -it --rm -v $HOME/admin-client:/admin-client <image_name> bash"
alias fusion-devkit-tenantadmin="docker run -it --rm -v $HOME/tenantadmin-client:/tenantadmin-client <image_name> bash"
```

## Using the Installer script
_Note: Not compabible with Windows. MacOS currently requires the Xcode developer tools to be installed if using this method._

-  Clone the repository:
```
git clone https://github.com/PureStorage-OpenConnect/fusion-client-devkit.git `pwd`/fusion-devkit-setup
```
- Move into the folder and run the setup.sh script, replacing the two variables with the proper key and path:
```
cd fusion-devkit-setup
sudo chmod +x setup.sh
./setup.sh API_CLIENT_ID PATH_TO_PRIV_KEY
```

## Tools currently available
These are the tools currently provided in the Kit:

### Fusion API Swagger web interface (Container image only)
The Swagger web interface for the Fusion API is included in the container image only. To launch view Swagger on the local desktop, you must expose the local tcp 8080 port to the host. To expose the container port 8080 to the localhost port 1234:  

``` docker run -it --rm -p 1234:8080 -v $HOME/api-client:/api-client <image_name> bash ```  

Now you may access swagger via http://127.0.0.1:1234

### HMCTL (pronounced "HM-cuttle")
HMCTL is the remote CLI utility provided with Fusion.

To check if HMCTL was configured correctly, run
```
hmctl version
```
After this install you should be able to run Consumer commands as seen in [this guide](https://support.purestorage.com/Pure_Fusion/Pure_Fusion_for_Storage_Consumers/Example_CLI_Commands).

### Python
Our Python library has full support for all Fusion APIs.

To run a smoke test:
```
python3 python/00_smoke_test.py
```
After installation is complete, there are sample scripts provided in the /python folder in the container image, and you can refer to [the documentation](https://github.com/PureStorage-OpenConnect/fusion-python-sdk) for guidance on writing your own Python scripts.

### Ansible
Our Ansible collection has full support for all Fusion APIs.

To run a smoke test:
```
ansible-playbook ansible/smoke_test.yml
```
After installation, there are sample playbooks provided in the /ansible folder, and you can check out the ansible collection from the [Ansible documentation page here](https://docs.ansible.com/ansible/latest/collections/purestorage/fusion/index.html#plugins-in-purestorage-fusion) for more information on the individual modules.

### Terraform
Our Terraform provider supports only consumer workflows in Fusion, not Provider workflows at this time. Terraform does not allow for a full smoke test since it is a consumer-focused provider and requires more Fusion configuration before it can execute.

After installation, there are sample Terraform files provided in the /terraform folder in the container image, and you can see the [Terraform module documentation here](https://registry.terraform.io/providers/PureStorage-OpenConnect/fusion/1.0.0) for guidance on writing your own Terraform templates.
