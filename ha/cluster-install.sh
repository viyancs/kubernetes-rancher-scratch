#!/bin/bash

# update package
sudo apt update -y && sudo apt install curl -y

# Install kubectl
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"

# validate binary
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl.sha256"
echo "$(cat kubectl.sha256)  kubectl" | sha256sum --check

sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
kubectl version --client

# Install RKE
curl -O https://github.com/rancher/rke/releases/download/v1.5.0/rke_linux-amd64
mv rke_linux-amd64 rke
mv rke /usr/bin/
chmod +x rke
rke --version
