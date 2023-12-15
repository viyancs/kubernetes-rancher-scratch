#!/bin/bash

# Check if Docker is installed
if ! command -v docker &> /dev/null; then
    # Install Docker prerequisites
    sudo apt update
    sudo apt install -y apt-transport-https ca-certificates curl software-properties-common
    
    # Add Docker's official GPG key
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

    # Add Docker repository for Ubuntu
    sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"

    # Update package index again
    sudo apt update

    # Install Docker
    sudo apt install -y docker-ce

    # Add current user to the docker group to run Docker commands without sudo
    sudo usermod -aG docker $USER

    echo "Docker has been installed successfully."
else
    echo "Docker is already installed."
fi

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
curl -LO https://github.com/rancher/rke/releases/download/v1.5.0/rke_linux-amd64
mv rke_linux-amd64 rke
mv rke /usr/bin/
chmod +x /usr/bin/rke
rke --version
