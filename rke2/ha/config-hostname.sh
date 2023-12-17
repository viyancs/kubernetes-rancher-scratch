#!/bin/bash

# Define an array of host entries (IP address followed by hostname)
declare -a host_entries=(
    "10.130.0.3 dev.srv1.vyn.com"
    "10.130.0.5 dev.srv2.vyn.com"
    "10.130.0.4 dev.srv3.vyn.com"
    "10.130.0.2 fxd.vyn.com"
    "10.130.0.6 agent1.vyn.com"
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

