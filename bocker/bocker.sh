#! /usr/bin/env bash
#------------------------------------------
# copyright(c) Aisuko. All rights reverved.
# Licensed under the GNU GENERAL PUBLIC LICENSE.
#------------------------------------------
#
# Maintainer: Aisuko
#
#


set -e

USERNAME=${1:-"azureuser"}


if [ "$(id -u)" -ne 0 ]; then
    echo -e "Please run as root that would be good."
    exit 1
fi

apt_get_update_if_needed()
{
    if  [ ! -d "/var/lib/apt/lists" ] || [ "$(ls /var/lib/apt/lists/ | wc -l)" = "0" ]; then
        echo "Running apt-get update..."
        sudo apt-get update
    else
        echo "Skipping the update."
    fi
}

# Update
apt_get_update_if_needed


package_list="apt-transport-https \
    ca-certificates \
    curl \
    software-properties-common"


echo "Install packages: ${package_list}"
sudo apt install -y ${package_list}


UBUNTU_GPG="https://download.docker.com/linux/ubuntu/gpg"

curl -fsSL ${UBUNTU_GPG} | sudo apt-key add -

echo "ADD docker stable repo"
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable"


echo "Install the latest version docker-ce"
sudo apt install -y docker-ce

# Add current user to the docker group
sudo usermod -aG docker ${USERNAME}

echo "Installed docker, show the status with the command 'sudo systemctl status docker', 
    please log out under current user manually in order to use docker command without root."

