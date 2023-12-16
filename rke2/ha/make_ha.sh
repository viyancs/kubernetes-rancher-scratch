#!/bin/bash

## RKE2 config HA ##
# create  rke2 folder
mkdir -p /etc/rancher/rke2/

# create rke2 config file
file_content=$(cat <<EOF
token: my-shared-secret
tls-san:
  - dev.srv1.vyn.com
  - dev.srv2.vyn.com
  - dev.srv3.vyn.com
EOF
)

# Specify the file path
file_path="/etc/rancher/rke2/config.yaml"

# Use echo to write the content to the file
echo "$file_content" > "$file_path"

# Display a message indicating the file creation
if [ -f "$file_path" ]; then
    echo "File '$file_path' created successfully."
else
    echo "Failed to create the file."
fi