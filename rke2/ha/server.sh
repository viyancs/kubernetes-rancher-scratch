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

# # Define the file path
# RKE2_CONFIG_FILE="/etc/rancher/rke2/config.yaml"

# # Content for the RKE2 config file
# CONFIG_CONTENT=$(cat <<EOF
# token: K101a2f45c2570e440bfed7c5aa206652123587c9996dac3467ce8b1956e47d1915::server:e7867265ddf5b04cfcf9c751bfc1e411
# tls-san:
#   - fxd.vyn.com
#   - 10.130.0.2
# EOF
# )

# Create the config directory if it doesn't exist
sudo mkdir -p "$(dirname "$RKE2_CONFIG_FILE")"

# Write the configuration content to the file
echo "$CONFIG_CONTENT" | sudo tee "$RKE2_CONFIG_FILE" > /dev/null

# Verify the content has been written
echo "RKE2 Config File created at $RKE2_CONFIG_FILE with the following content:"
sudo cat "$RKE2_CONFIG_FILE"

apt install ufw -y

# install rke2 server
curl -sfL https://get.rke2.io | sh -s -- --verbose
systemctl enable rke2-server.service
systemctl start rke2-server.service
#journalctl -u rke2-server -f
cp /var/lib/rancher/rke2/bin/kubectl /usr/local/bin

# Define the commands to be appended to ~/.bashrc
EXPORT_COMMANDS=$(cat <<'EOF'
export KUBECONFIG=/etc/rancher/rke2/rke2.yaml
export PATH=$PATH:/opt/rke2/bin:/var/lib/rancher/rke2/bin
EOF
)

# Check if the export commands already exist in ~/.bashrc
if ! grep -qxF "$EXPORT_COMMANDS" ~/.bashrc; then
    # Add the commands to the end of ~/.bashrc
    echo "$EXPORT_COMMANDS" >> ~/.bashrc

    # Source the updated ~/.bashrc to apply changes to the current shell
    source ~/.bashrc

    # Display a message indicating the changes
    echo "Export commands added to ~/.bashrc file."
else
    echo "Export commands already exist in ~/.bashrc. Skipping addition."
fi
cat /var/lib/rancher/rke2/server/node-token