#!/bin/bash
### Prerequisites RKE2 ###
## network issue https://docs.rke2.io/known_issues#networkmanager
# Define the configuration content
CONFIG_CONTENT="[keyfile]\nunmanaged-devices=interface-name:cali*;interface-name:flannel*"

# Define the file path for the configuration file
CONFIG_FILE="/etc/NetworkManager/conf.d/rke2-canal.conf"

# Echo the content to the file
echo -e "$CONFIG_CONTENT" | sudo tee "$CONFIG_FILE" > /dev/null

# Display a message indicating the file creation
if [ -f "$CONFIG_FILE" ]; then
    echo "Configuration file '$CONFIG_FILE' created successfully."
else
    echo "Failed to create the configuration file."
fi

apt install ufw -y

# install rke2 server
curl -sfL https://get.rke2.io | sh -
systemctl enable rke2-server.service
systemctl start rke2-server.service
#journalctl -u rke2-server -f
cp /var/lib/rancher/rke2/bin/kubectl /usr/local/bin
export KUBECONFIG=/etc/rancher/rke2/rke2.yaml
export PATH=$PATH:/opt/rke2/bin:/var/lib/rancher/rke2/bin
cat /var/lib/rancher/rke2/server/node-token