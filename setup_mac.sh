#!/bin/zsh

# Args
apiClient="$1"
pathToKey="$2"

red='\033[0;31m'
green='\033[0;32m'
blue='\033[0;34m'
nocolor='\033[0m'

echo -e "${red}"
# check this scripts is given 2 argvs
if [ "$#" -ne 2 ]; then
    echo "Missing parameters: API_CLIENT and PRIV_KEY_FILE"
    echo -e "${blue}Run: $0 API_CLIENT PRIV_KEY_FILE${nocolor}"
    exit
fi

# Check if apiClient argv is empty
if [[ -z "$apiClient" ]]; then
  echo "Missing API Client ID"
  exit
fi
# Check if pathToKey argv is empty
if [[ -z "$pathToKey" ]]; then
  echo "Missing Private Key path"
  exit
elif ! [[ -f "$pathToKey" ]]; then # check if pathToKey is not a valid file
  echo "Private Key is not a valid file: $pathToKey"
  exit
fi

# check that pathToKey is absolute and not relative
# absolute = /home/user/folder/priv_key.pem
# relative = private_key.pem
case $pathToKey in
  /*) echo -e "${green}Starting install setup${nocolor}" ;;
   *) echo -e "Please use absolute path for private key: $pathToKey${nocolor}"
      echo -e "Example: $(pwd)/$pathToKey"
      exit ;;
esac

export API_CLIENT="$apiClient"
export PRIV_KEY_FILE="$pathToKey"

echo "
██████  ██    ██ ██████  ███████ ███████ ████████  ██████  ██████   █████   ██████  ███████
██   ██ ██    ██ ██   ██ ██      ██         ██    ██    ██ ██   ██ ██   ██ ██       ██
██████  ██    ██ ██████  █████   ███████    ██    ██    ██ ██████  ███████ ██   ███ █████
██      ██    ██ ██   ██ ██           ██    ██    ██    ██ ██   ██ ██   ██ ██    ██ ██
██       ██████  ██   ██ ███████ ███████    ██     ██████  ██   ██ ██   ██  ██████  ███████
"

if [[ ! "$(uname -s)" == "Darwin" ]]; then
  echo -e "${red}Not macOS${nocolor}"
  exit
fi

# PFCTL setup

echo -e "${blue}################################"
echo -e "#         PFCTL setup          #"
echo -e "################################${nocolor}"

echo -e "${green}Downloading PFCTL..."
if [[ "$(uname -m)" == "arm64" ]]; then
  sudo curl -L -o ./pfctl.tar.gz https://github.com/PureStorage-OpenConnect/pfctl/releases/latest/download/pfctl-darwin-arm64.tar.gz
else
  sudo curl -L -o ./pfctl.tar.gz https://github.com/PureStorage-OpenConnect/pfctl/releases/latest/download/pfctl-darwin-amd64.tar.gz
fi

tar -xf pfctl.tar.gz -C /usr/local/bin
rm pfctl.tar.gz

# check last command exit status
if [ $? -eq 0 ]; then
  echo -e "${green}PFCTL download to: /usr/local/bin/pfctl"
else
  echo -e "${red}PFCTL fail to download"
  exit
fi
# give pfctl execute permissions
sudo chmod +x /usr/local/bin/pfctl
# create folder .pure under home folder
mkdir -p ~/.pure/


# create file: ~/.pure/fusion.json (replace if exist)
sudo echo '{
  "default_profile": "main",
  "profiles": {
    "main": {
      "env": "pure1",
      "endpoint": "https://api.pure1.purestorage.com/fusion",
      "auth": {
        "issuer_id": "'${apiClient}'",
        "private_pem_file": "'${pathToKey}'"
      }
    }
  }
}' | sudo tee ~/.pure/fusion.json

# PFCTL test
echo -e "${blue}################################"
echo -e "#         PFCTL test           #"
echo -e "################################${nocolor}"

# pfctl conflicts with the MacOS Packet Filter Firewall Utility that has the same name
/usr/local/bin/pfctl region list

# Python setup
echo -e "${blue}################################"
echo -e "#         Python setup         #"
echo -e "################################${nocolor}"

python3 -m ensurepip

echo -e "${blue}################################"
echo -e "#    Python Lib: Purefusion    #"
echo -e "################################${nocolor}"
pip3 install purefusion
pip3 install netaddr
pip3 install cryptography==3.4.8

# Python smoke test
echo -e "${blue}################################"
echo -e "#      Python smoke test       #"
echo -e "################################${nocolor}"
sudo chmod +x python/00_smoke_test.py
python3 python/00_smoke_test.py

# check if last command fail
if [ $? -eq 1 ]; then
  echo -e "${red}################################"
  echo -e "#   FAIL: Python smoke test    #"
  echo -e "################################${nocolor}"
fi

# Ansible setup
echo -e "${blue}################################"
echo -e "#         Ansible setup        #"
echo -e "################################${nocolor}"

python3 -m pip install --user ansible
sudo ansible-galaxy collection install purestorage.fusion
sudo ansible-galaxy collection install community.general
sudo ansible-galaxy collection install ansible.posix

echo -e "${blue}################################"
echo -e "#     Ansible smoke test     #"
echo -e "################################${nocolor}"
sudo ansible-playbook ansible/smoke_test.yml

# check if last command fail
if [ $? -eq 0 ]; then
    # if success
  echo -e "${green}################################"
  echo -e "#     OK:Ansible smoke test     #"
  echo -e "################################${nocolor}"
else
  echo -e "${red}################################"
  echo -e "#    FAIL:Ansible smoke test   #"
  echo -e "################################${nocolor}"
fi

# Terraform setup
echo -e "${blue}################################"
echo -e "#       Terraform setup        #"
echo -e "################################${nocolor}"

if [[ "$(uname -m)" == "arm64" ]]; then
  sudo curl -L -o ./terraform.zip https://releases.hashicorp.com/terraform/1.3.8/terraform_1.3.8_darwin_arm64.zip
else
  sudo curl -L -o ./terraform.zip https://releases.hashicorp.com/terraform/1.3.8/terraform_1.3.8_darwin_amd64.zip
fi
unzip ./terraform.zip
chmod +x ./terraform
if [[ -f "/usr/local/bin/terraform" ]]; then
  sudo rm /usr/local/bin/terraform
fi
sudo mv ./terraform /usr/local/bin/terraform
rm ./terraform
sudo rm ./terraform.zip

# Terraform test
echo -e "${blue}################################"
echo -e "#       Terraform test        #"
echo -e "################################${nocolor}"

color_terraform="$red"
terraform_version=$(terraform -version)
# check last command exit status
if [ $? -eq 0 ]; then
  color_terraform="$green"
fi
echo -e "${color_terraform}################################"
echo -e "$terraform_version"
echo -e "################################${nocolor}"