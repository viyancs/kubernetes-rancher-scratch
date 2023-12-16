#!/bin/bash

# Define an array of host entries (IP address followed by hostname)
declare -a host_entries=(
    "10.130.0.2 dev.srv1.vyn.com"
    "10.130.0.3 dev.srv2.vyn.com"
    "10.130.0.4 dev.srv3.vyn.com"
)

# Function to check and add host entries
add_hosts() {
    for host_entry in "${host_entries[@]}"; do
        if ! grep -qE "^\s*$host_entry\s*$" /etc/hosts; then
            echo "$host_entry" | sudo tee -a /etc/hosts >/dev/null
            echo "Added: $host_entry"
        else
            echo "Already exists: $host_entry"
        fi
    done
}

# Call the function to add host entries
add_hosts

## add server node to connect into fixed server ##
# create  rke2 folder
mkdir -p /etc/rancher/rke2/

# create rke2 config file
file_content=$(cat <<EOF
server: https://dev.srv1.vyn.com:9345
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